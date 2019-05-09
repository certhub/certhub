certhub-dehydrated-run@.service
===============================

Synopsis
--------

**certhub-dehydrated-run@.service**

**certhub-dehydrated-run@.path**


Description
-----------

A service which runs :program:`certhub-dehydrated-run` with a CSR read from the
config directory. The resulting fullchain certificate is committed to the
repository. A commit message is generated automatically.

A path unit which runs the service unit if the expiry status file managed by
:program:`certhub-cert-expiry@.service` exists or if the CSR file changed.

The instance name (systemd instance string specifier ``%i``) is used as the
basename of the configuration and the resulting certificate file.


Environment
-----------

.. envvar:: CERTHUB_REPO

   URL of the repository where certificates are stored. Defaults to:
   ``/var/lib/certhub/certs.git``

.. envvar:: CERTHUB_CERT_PATH

   Path to the certificate file inside the repository. Defaults to:
   ``{WORKDIR}/%i.fullchain.pem``

.. envvar:: CERTHUB_CSR_PATH

   Path to the CSR file. Defaults to:
   ``/etc/certhub/%i.csr.pem``

.. envvar:: CERTHUB_DEHYDRATED_ARGS

   Additional Arguments for :program:`dehydrated --signcsr` run. Empty by
   default.

.. envvar:: CERTHUB_DEHYDRATED_CONFIG

   Path to a dehydrated configuration file. Defaults to:
   ``/etc/certhub/%i.dehydrated.conf``


Files
-----

.. envfile:: /etc/certhub/env

   Optional environment file shared by all instances and certhub services.

.. envfile:: /etc/certhub/%i.env

   Optional per-instance environment file shared by all certhub services.

.. envfile:: /etc/certhub/certhub-dehydrated-run.env

   Optional per-service environment file shared by all certhub service
   instances.

.. envfile:: /etc/certhub/%i.certhub-dehydrated-run.env

   Optional per-instance and per-service environment file.


See Also
--------

:manpage:`certhub-cert-expiry@.service`,
:manpage:`certhub-dehydrated-run(1)`,
:manpage:`certhub-message-format(1)`
