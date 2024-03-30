Systemd Setup
=============

Certhub ships with a host of systemd ``service``, ``timer`` and ``path`` units
which can be combined in various ways to satisfy different use cases.

Most of them are designed to run as an unprivileged system user. The systemd
units default to ``certhub`` as the UID as well as the primary GID. Also the
home directory by default is expected to be located at ``/var/lib/certhub``.


Certhub User
------------

Add the ``certhub`` user and group on the target system. Use the
``--shell /usr/bin/git-shell`` option in order to enable ``git`` repository
replication.

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

    - name: Git configured
      become: yes
      become_user: certhub
      loop:
        - { name: "user.name", value: Certhub }
        - { name: "user.email", value: "certhub@{{ ansible_fqdn }}" }
        - { name: "push.default", value: simple}
      git_config:
        name: "{{ item.name }}"
        value: "{{ item.value }}"
        scope: global

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
hooks need to be configured using an environment file normally located in
:envfile:`/etc/certhub/%i.certhub-certbot-run.env` and
:envfile:`/etc/certhub/%i.certhub-dehydrated-run.env`.  An example for
`certbot <https://github.com/certhub/certhub/tree/main/integration-test/src/github/etc/certhub-certbot-run.env.in>`__
and
`dehydrated <https://github.com/certhub/certhub/tree/main/integration-test/src/github/etc/certhub-dehydrated-run.env.in>`__
configuration is part of the integration test suite. See the manpages
:doc:`certhub-hook-lexicon-auth.8` and :doc:`certhub-hook-nsupdate-auth.8` for
more detailed information about the involved environment variables.

In the case of lego the challenge method is selected using command line
arguments to the lego binary, authentication tokens are passed in via
environment variables. All configuration is passed in via an environment file
normally located in :envfile:`/etc/certhub/%i.certhub-lego-run.env`. An
`example <https://github.com/certhub/certhub/tree/main/integration-test/src/github/etc/certhub-lego-run.env.in>`__
configuration is part of the integration test suite. See the manpage
:doc:`certhub-lego-run@.service.8` for more detailed information about the
involved environment variables.

Note that it is not recommended to specify secrets like API tokens in
environment variables or command line flags. Regrettably most of today's
software authors seem to ignore this fact. An effective way to prevent secrets
from leaking via process table is to keep them in files with tight access
restrictions. Regrettably neither Lexicon_ nor lego do support this approach.
Thus for production grade setups it is unavoidable to either use the
``nsupdate`` method or implement custom challenge hook scripts which are
capable of reading API tokens from files.

Also note that HTTP-01 validation can be implemented quite easily if a reverse
proxy serving the whole range of sites is already in place. In this case it is
enough to proxy the path ``.well-known/acme-challenge`` to the certhub
controller and then run a HTTP server and an ACME client in webroot-mode.

Refer to the following section for detailed directives on how to customize
services via drop-ins.

.. _Lexicon: https://github.com/AnalogJ/lexicon


Systemd Unit Customization
--------------------------

Certhub ships with `systemd units <https://github.com/certhub/certhub/tree/main/lib/systemd>`__
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


CSR
^^^

Generate a CSR from the TLS servers private key. When working with Ansible use
`delegation <https://docs.ansible.com/ansible/latest/user_guide/playbooks_delegation.html#delegation>`__
to run the ``openssl req`` command on another host than the certhub controller.
Add the CSR to ``/etc/certhub/${DOMAIN}.csr.pem``. In simple setups it is
recommended to use the domain name as the config base name.

Shell:

.. code-block:: shell

    $ export SERVER=tls-server.example.com
    $ export DOMAIN=tls-server.example.com
    $ ssh "${SERVER}" sudo openssl req -new \
        -key "/etc/ssl/private/${DOMAIN}.key.pem" \
        -subj "/CN=${DOMAIN}" \
        | sudo tee "/etc/certhub/${DOMAIN}.csr.pem"

Ansible:

.. code-block:: yaml

    - name: CSR generated
      delegate_to: "{{ SERVER }}"
      changed_when: false
      register: csr_generated
      command: >
        openssl req -new
        -key "/etc/ssl/private/{{ DOMAIN }}.key.pem"
        -subj "/CN={{ DOMAIN }}"

    - name: CSR configured
      register: csr_configured
      copy:
        dest: "/etc/certhub/{{ DOMAIN }}.csr.pem"
        content: "{{ csr_generated.stdout }}
        owner: root
        group: root
        mode: 0644


ACME Client Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^

Add additional configuration for the ACME client to one of the following files:
``/etc/certhub/${DOMAIN}.certbot.ini``,
``/etc/certhub/${DOMAIN}.dehydrated.conf`` or
``/etc/certhub/${DOMAIN}.certhub-lego-run.env``. Working examples for testing
purposes are part of certhub
`integration tests <https://github.com/certhub/certhub/tree/main/integration-test/src/github/etc>`__


Initial Certificate
^^^^^^^^^^^^^^^^^^^

Run ``certhub-${ACME_CLIENT}-run@${DOMAIN}.service`` once in order to
obtain the first certificate and add it to the repository.

Example for ``ACME_CLIENT=certbot`` and ``DOMAIN=tls-server.example.com``

.. code-block:: shell

    $ export ACME_CLIENT=certbot
    $ export DOMAIN=tls-server.example.com
    $ sudo systemctl start "certhub-${ACME_CLIENT}-run@${DOMAIN}.service"

Ansible:

.. code-block:: yaml

    - name: Certificate issued
      systemd:
        name: "certhub-{{ ACME_CLIENT }}-run@{{ DOMAIN }}.service"
        state: started


Configure Certificate Renewal
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Enable  and start ``timer`` and ``path`` units.

Shell:

.. code-block:: shell

    $ export DOMAIN=tls-server.example.com
    $ sudo systemctl enable --now "certhub-cert-expiry@${DOMAIN}.path"
    $ sudo systemctl enable --now "certhub-cert-expiry@${DOMAIN}.timer"
    $ sudo systemctl enable --now "certhub-certbot-run@${DOMAIN}.path"

Ansible:

.. code-block:: yaml

    - name: Path and timer units enabled and started
      loop:
        - "certhub-cert-expiry@{{ DOMAIN }}.path"
        - "certhub-cert-expiry@{{ DOMAIN }}.timer"
        - "certhub-certbot-run@{{ DOMAIN }}.path"
      systemd:
        name: "{{ item }}"
        enabled: true
        state: started


Certificate Distribution
------------------------

In order to propagate certificates to tls servers it is recommended to mirror
the repository from the certhub controller to the respective machines. The
``certhub-repo-push@.service`` unit can be used to propagate these changes to
another host, ``certhub-repo-push@.path`` unit to trigger it automatically
whenever the ``master`` branch of the repository changes.

Note, ``certhub-repo-push@.service`` requires working SSH access via public key
authentication to the remote end.

This unit takes the full remote URL including the path as the service instance
name which needs to be escaped using ``systemd-escape --template``. Note, when
copy-pasting output from ``system-escape`` into a shell then it is necessary to
escape backslashes with an additional backslash.

Shell:

.. code-block:: shell

    $ export REMOTE="tls-server.example.com:/var/lib/certhub/certs.git"
    $ export PATH_UNIT="$(systemd-escape --template certhub-repo-push@.path ${REMOTE})"
    $ export SERVICE_UNIT="$(systemd-escape --template certhub-repo-push@.service ${REMOTE})"
    $ sudo systemctl enable --now "${PATH_UNIT}"
    $ sudo systemctl start "${SERVICE_UNIT}"

Ansible:

.. code-block:: yaml

    tasks:
      - name: Certificate distribution activated
        notify: Certificate distribution run
        vars:
          UNIT: "{{ lookup('pipe','systemd-escape --template certhub-repo-push@.path ' + REMOTE|quote) }}"
        systemd:
          name: "{{ UNIT }}"
          enabled: true
          state: started

    handlers:
      - name: Certificate distribution run
        vars:
          UNIT: "{{ lookup('pipe','systemd-escape --template certhub-repo-push@.service ' + REMOTE|quote) }}"
        systemd:
          name: "{{ UNIT }}"
          state: started


Certificate export and service reload
-------------------------------------

Whenever a new commit is pushed to the local repository on a tls server node,
selected certificates may be exported such that they can be used in the config
of tls servers. Also affected tls services should be reloaded wenever an
exported certificate was renewed. Enable and start
``certhub-cert-export@.path`` and ``certhub-cert-reload@.path`` in order to
automate this process on tls server nodes. Both of these units take a
certificate configuration basename as their instance name.

All units which should be reloaded whenever the exported certificate changes
should be listed in ``/etc/certhub/${DOMAIN}.services-reload.txt``.

The default destination for exported certificates is ``/var/lib/certhub/certs``.

Shell:

.. code-block:: shell


    $ export DOMAIN=tls-server.example.com
    $ sudo -u certhub mkdir /var/lib/certhub/certs
    $ sudo tee "/etc/certhub/${DOMAIN}.services-reload.txt" <<EOF
    nginx.service
    EOF
    $ sudo systemctl enable --now "certhub-cert-export@${DOMAIN}.path"
    $ sudo systemctl enable --now "certhub-cert-reload@${DOMAIN}.path"
    $ sudo systemctl start "certhub-cert-export@${DOMAIN}.service"

Ansible:

.. code-block:: yaml

    tasks:
      - name: Certhub certificate directory exists
        file:
          path: /var/lib/certhub/certs
          state: directory
          owner: certhub
          group: certhub
          mode: 0755

      - name: Service reload configuration
        copy:
          dest: "/etc/certhub/{{ DOMAIN }}.services-reload.txt"
          owner: root
          group: root
          mode: 0644
          content: |
            nginx.service

      - name: Certificate export and service reload path units enabled and started
        notify: Certificate exported
        loop:
          - "certhub-cert-export@{{ DOMAIN }}.path"
          - "certhub-cert-reload@{{ DOMAIN }}.path"
        systemd:
          name: "{{ item }}"
          enabled: true
          state: started

    handlers:
      - name: Certificate exported
        systemd:
          name: "certhub-cert-export@{{ DOMAIN }}.service"
          state: started


Sending certificates
--------------------

Similar to the export/reload scenario described above, it is also possible to
send exported certificates to another destination/process. Enable and start
``certhub-cert-export@.path`` and ``certhub-cert-send@.path`` in order to
automate this process. Both of these units take a certificate configuration
basename as their instance name.

List all destinations the certificate should be sent to in
``/etc/certhub/${DOMAIN}.destinations-send.txt``. By default the certificate
will be sent using the ``mail`` command. This can be changed using the
:envvar:`CERTHUB_CERT_SEND_COMMAND`. A good place to specify the variable is,
e.g., :envfile:`/etc/certhub/%i.certhub-cert-send.env`.

Note that the certificate is written to ``stdin`` of the specified command.
Hence it is quite easy to send it to remote scripts using ``ssh``.

Shell:

.. code-block:: shell


    $ export DOMAIN=tls-server.example.com
    $ sudo -u certhub mkdir /var/lib/certhub/certs
    $ sudo tee "/etc/certhub/${DOMAIN}.destinations-send.txt" <<EOF
    audit@example.com
    EOF
    $ sudo systemctl enable --now "certhub-cert-export@${DOMAIN}.path"
    $ sudo systemctl enable --now "certhub-cert-send@${DOMAIN}.path"
    $ sudo systemctl start "certhub-cert-export@${DOMAIN}.service"

Ansible:

.. code-block:: yaml

    tasks:
      - name: Certhub certificate directory exists
        file:
          path: /var/lib/certhub/certs
          state: directory
          owner: certhub
          group: certhub
          mode: 0755

      - name: Certificate send configuration
        copy:
          dest: "/etc/certhub/{{ DOMAIN }}.destinations-send.txt"
          owner: root
          group: root
          mode: 0644
          content: |
            audit@example.com

      - name: Certificate export and send path units enabled and started
        notify: Certificate exported
        loop:
          - "certhub-cert-export@{{ DOMAIN }}.path"
          - "certhub-cert-send@{{ DOMAIN }}.path"
        systemd:
          name: "{{ item }}"
          enabled: true
          state: started

    handlers:
      - name: Certificate exported
        systemd:
          name: "certhub-cert-export@{{ DOMAIN }}.service"
          state: started
