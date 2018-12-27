certhub-cert-export@.service
============================

Synopsis
--------

**certhub-cert-export@.service**

**certhub-cert-export@.path**


Description
-----------

A service which copies a certificate from the repository to the local
filesystem.

A path unit which runs the service unit whenever the master branch of the
local certhub repository is updated.

The instance name (systemd instance string specifier ``%i``) is used as the
basename of the configuration and the resulting certificate file.


Environment
-----------

.. envvar:: CERTHUB_REPO

   URL of the repository where certificates are stored. Defaults to:
   ``/var/lib/certhub/certs.git``

.. envvar:: CERTHUB_CERT_EXPORT_SRC

   File / directory inside the repository which should be exported. Defaults to:
   ``{WORKDIR}/%i.fullchain.pem``

.. envvar:: CERTHUB_CERT_EXPORT_DEST

   File / directory where the certificate should be placed. Defaults to:
   ``/var/lib/certhub/certs/%i.fullchain.pem``

.. envvar:: CERTHUB_CERT_EXPORT_RSYNC_ARGS

   Arguments for rsync. Defaults to:
   ``--checksum --delete --devices --links --perms --recursive --specials --verbose``


Files
-----

.. envfile:: /etc/certhub/env

   Optional environment file shared by all instances and certhub services.

.. envfile:: /etc/certhub/%i.env

   Optional per-instance environment file shared by all certhub services.

.. envfile:: /etc/certhub/certhub-cert-export.env

   Optional per-service environment file shared by all certhub service
   instances.

.. envfile:: /etc/certhub/%i.certhub-cert-export.env

   Optional per-instance and per-service environment file.


See Also
--------

:manpage:`rsync(1)`
