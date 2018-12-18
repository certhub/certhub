Systemd Setup
=============

Certhub ships with a host of systemd ``service``, ``timer`` and ``path`` units
which can be combined in various ways to satisfy different use cases.

Most of them are designed to run as an unprivileged system user. The systemd
units default to ``certhub`` as the UID as well as the primary GID. Also the
home directory by default is expected to be located at ``/var/lib/certhub``.


Certhub User
------------

Add the ``certhub`` user and group on the target system. If ``git``
repositories should be replicated to other hosts and this host receives changes
from other hosts respectively, then it is recommended to supply
``--shell /usr/bin/git-shell`` option.

.. code-block:: shell

    $ sudo adduser --system --group --home /var/lib/certhub --shell /usr/bin/git-shell certhub

Same thing as an Ansible task:

.. code-block:: yaml

    - name: Certhub user present
      user:
        name: certhub
        state: present
        system: yes
        home: /var/lib/certhub
        shell: /usr/bin/git-shell


Directory Structure
-------------------

Configuration for each certificate is expected in ``/etc/certhub``. This
directory must not be writable by the ``certhub`` user. Any files holding
secrets such as API tokens or DNS TSIG keys should be owned by ``root`` with
group ``certhub`` and permissions ``0640`` in order to prevent leaking
information to other unprivileged processes.

.. code-block:: shell

    $ sudo mkdir /etc/certhub

.. code-block:: yaml

    - name: Certhub config directory present
      file:
        path: /etc/certhub
        state: directory
        owner: root
        group: root
        mode: 0755

A status directory is used to trigger certificate renewal via systemd ``path``
units. The ``certhub`` user obviously needs write access to that directory. By
default it is located at ``/var/lib/certhub/status``.

.. code-block:: shell

    $ sudo -u certhub mkdir /var/lib/certhub/status

.. code-block:: yaml

    - name: Certhub status directory present
      file:
        path: /var/lib/certhub/status
        state: directory
        owner: certhub
        group: certhub
        mode: 0755


Local Repository
----------------

By default systemd units expect the local certificate repository in
``/var/lib/certhub/certs.git``. Also it is recommended to at least set
``user.name`` and ``user.email`` in the ``git`` configuration of the
``certhub`` user. Some ``git`` versions complain if ``push.default`` is not
set. Thus it is best to specify that explicitly as well.

.. code-block:: shell

    $ sudo -u certhub git config --global user.name Certhub
    $ sudo -u certhub git config --global user.email certhub@$(hostname -f)
    $ sudo -u certhub git config --global push.default simple
    $ sudo -u certhub git init --bare /var/lib/certhub/certs.git
    $ sudo -u certhub git gau-exec /var/lib/certhub/certs.git git commit --allow-empty -m'Init'

.. code-block:: yaml

    - name: Git config present
      loop:
        - { section: user, option: name, value: Certhub }
        - { section: user, option: email, value: "certhub@{{ inventory_hostname }}" }
        - { section: push, option: default, value: simple}
      ini_file:
        path: /var/lib/certhub/.gitconfig
        section: "{{ item.section }}"
        option: "{{ item.option }}"
        value: "{{ item.value }}"
        owner: certhub
        group: certhub
        mode: 0644

    - name: Certhub repository present
      become: yes
      become_user: certhub
      command: >
        git init --bare /var/lib/certhub/certs.git
      arg:
        creates: /var/lib/certhub/certs.git

    - name: Certhub repository initialized
      become: yes
      become_user: certhub
      command: >
        git gau-exec /home/certhub/certs.git
        git commit --allow-empty -m'Init'
      arg:
        creates: /var/lib/certhub/certs.git/refs/heads/master


ACME Client Setup
-----------------

ACME clients need a way to store Let's Encrypt account keys. By default systemd
units expect home directories for the supported ACME clients to be inside
``/var/lib/certhub/private/``. This directory must not be world-readable.

.. code-block:: shell

    $ sudo -u certhub mkdir -m 0700 /var/lib/certhub/private

.. code-block:: yaml

    - name: Certhub private directory present
      file:
        path: /var/lib/certhub/private
        state: directory
        owner: certhub
        group: certhub
        mode: 0700


Certbot Setup
^^^^^^^^^^^^^

Certbot needs some special configuration in order to make it run as an
unprivileged user. The following configuration directives need to be placed
inside ``/var/lib/certhub/.config/letsencrypt/cli.ini``.

.. :

    work-dir = /var/lib/certhub/private/certbot/work
    config-dir = /var/lib/certhub/private/certbot/config
    logs-dir = /var/lib/certhub/private/certbot/logs

Also the referenced directories should be created before running certbot for
the first time.

Shell:

.. code-block:: shell

    $ sudo -u certhub mkdir -p /var/lib/certhub/private/certbot/{work,config,logs}
    $ sudo -u certhub mkdir -p /var/lib/certhub/.config/letsencrypt
    $ sudo -u certhub tee /var/lib/certhub/.config/letsencrypt/cli.ini <<EOF
    work-dir = /var/lib/certhub/private/certbot/work
    config-dir = /var/lib/certhub/private/certbot/config
    logs-dir = /var/lib/certhub/private/certbot/logs
    EOF

Ansible:

.. code-block:: yaml

    - name: Certbot directory structure present
      loop:
        - /var/lib/certhub/.config/letsencrypt
        - /var/lib/certhub/private/certhub/work
        - /var/lib/certhub/private/certhub/config
        - /var/lib/certhub/private/certhub/log
      file:
        path: "{{ item }}"
        state: directory
        recursive: true
        owner: certhub
        group: certhub
        mode: 0755

    - name: Certbot cli.ini present
      copy:
        dest: /var/lib/certhub/.config/letsencrypt/cli.ini
        owner: certhub
        group: certhub
        mode: 0755
        content: |
          work-dir = /var/lib/certhub/private/certbot/work
          config-dir = /var/lib/certhub/private/certbot/config
          logs-dir = /var/lib/certhub/private/certbot/logs


Dehydrated Setup
^^^^^^^^^^^^^^^^

Shell:

.. code-block:: shell

    $ sudo -u certhub mkdir /var/lib/certhub/private/dehydrated

Ansible:

.. code-block:: yaml

    - name: Dehydrated directory present
      file:
        path: /var/lib/certhub/private/dehydrated
        state: directory
        owner: certhub
        group: certhub
        mode: 0755


Lego Setup
^^^^^^^^^^

Shell:

.. code-block:: shell

    $ sudo -u certhub mkdir -p /var/lib/certhub/private/lego/{accounts,certificates}

Ansible:

.. code-block:: yaml

    - name: Lego directory structure present
      loop:
        - /var/lib/certhub/private/lego/accounts
        - /var/lib/certhub/private/lego/certificates
      file:
        path: "{{ item }}"
        state: directory
        recursive: true
        owner: certhub
        group: certhub
        mode: 0755


Domain Validation
^^^^^^^^^^^^^^^^^

Choose the challenge method which best suits the infrastructure. DNS-01
challenge is unavoidable for wildcard certificates. Currently DNS-01 is the
only method which is supported out-of-the box by certhub and which is covered
by integration tests.

Certhub ships with DNS-01 challenge hooks for ``nsupdate`` and Lexicon_. The
hooks need to be configured via the
`hook-nsupdate-auth.conf <https://github.com/znerol/certhub/blob/master/lib/systemd/dropins/hook-nsupdate-auth.conf>`__
and `hook-lexicon-auth.conf <https://github.com/znerol/certhub/blob/master/lib/systemd/dropins/hook-lexicon-auth.conf>`__
unit drop-ins shipped with certhub.

There is a separate `lego-challenge.conf <https://github.com/znerol/certhub/blob/master/lib/systemd/dropins/lego-challenge.conf>`
drop-in for lego.

Note that it is not recommended to specify secrets like API tokens in
environment variables or command line flags. Regrettably most of todays
software authors seem ignore this fact. An effective way to prevent secrets
from leaking via process table is to keep them in files with tight access
restrictions. Regrettably neither Lexicon_ nor lego do support this approach.
Thus for production grade setups it is unavoidable to either use the
``nsupdate`` method or implement custom challenge hook scripts.

Also note that HTTP-01 validation can be implemented quite easily if a reverse
proxy serving the whole range of sites is already in place. In this case it is
enough to proxy the path ``.well-known/acme-challenge`` to the certhub
controller and then run a HTTP server and an ACME client in webroot-mode.

Refer to the following section for detailed directives on how to customize
services via drop-ins.


Systemd Unit Customization
--------------------------

Certhub ships with `systemd units <https://github.com/znerol/certhub/tree/master/lib/systemd>`
which are capable of running one of the supported ACME clients in order to
issue or renew a certificate and then store it in the certificate repository.

All the units are extensively configurable via systemd unit drop-ins. Units and
drop-ins shipped with certhub are located in ``lib/systemd/system`` inside the
installation prefix (usually ``/usr/local``). Create corresponding drop-in
directories inside ``/etc/systemd/system`` and then copy over selected drop-ins
in order to customize certhub ``service``, ``path`` and ``timer`` units.


Certificates
------------

All systemd units are designed as templates. The instance name serves as the
basename for configuration as well as generated certificates.

In order to avoid problems it is recommended to only use characters allowed in
path components. I.e., alphanumeric plus URL-safe special characters such as
the period and minus.

The following steps are required to configure a new certificate.

* Generate a CSR from the TLS servers private key. When working with Ansible
  use `delegation <https://docs.ansible.com/ansible/latest/user_guide/playbooks_delegation.html#delegation>`__
  to run the ``openssl req`` command on another host than the certhub
  controller.
* Add the CSR to ``/etc/certhub/<basename>.csr.pem``. In simple setups it is
  recommended to use the domain name as the config base name.
* Add additional configuration for the ACME client to one of the following
  files: ``/etc/certhub/<basename>.certbot.ini``,
  ``/etc/certhub/<basename>.dehydrated.conf`` or
  ``/etc/certhub/<basename>.lego.args``. Working examples for testing purposes
  are part of certhub `integration tests
  <https://github.com/znerol/certhub/tree/master/integration-test/src/travis/etc>`__
* Run the ACME client once in order to initially optain the certificate:
  ``systemctl start certhub-<acme-client-name>-run@<basename>.service``
* Setup automatic renewal via expiry check:
  ``systemctl enable --now certhub-<acme-client-name>-run@<basename>.path``
  ``systemctl enable --now certhub-cert-expiry@<basename>.timer``
  ``systemctl enable --now certhub-cert-expiry@<basename>.path``
  ``systemctl enable certhub-cert-expiry@<basename>.service``

.. _Lexicon: https://github.com/AnalogJ/lexicon
