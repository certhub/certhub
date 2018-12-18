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


Private ACME Client Directories
-------------------------------

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
      become_user: certhub
      register: certhub_repo_result
      command: >
        git init --bare /var/lib/certhub/certs.git
      arg:
        creates: /var/lib/certhub/certs.git

    - name: Certhub repository initialized
      become_user: certhub
      when: certhub_repo_result is changed
      command: >
        git gau-exec /home/certhub/certs.git
        git commit --allow-empty --message='Initial import'
