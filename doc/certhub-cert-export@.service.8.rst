certhub-cert-export@.service
============================

Synopsis
--------

**certhub-cert-export@.service**


Description
-----------

A service which copies a certificate from the repository to the local
filesystem.

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


See Also
--------

:manpage:`rsync(1)`
