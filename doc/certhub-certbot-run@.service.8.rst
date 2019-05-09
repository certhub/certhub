certhub-certbot-run@.service
============================

Synopsis
--------

**certhub-certbot-run@.service**

**certhub-certbot-run@.path**


Description
-----------

A service which runs :program:`certhub-certbot-run` with a CSR read from the
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

.. envvar:: CERTHUB_CERTBOT_ARGS

   Additional Arguments for :program:`certbot certonly` run. Defaults to:
   ``--non-interactive``

.. envvar:: CERTHUB_CERTBOT_CONFIG

   Path to a certbot configuration file. Defaults to:
   ``/etc/certhub/%i.certbot.ini``


Files
-----

.. envfile:: /etc/certhub/env

   Optional environment file shared by all instances and certhub services.

.. envfile:: /etc/certhub/%i.env

   Optional per-instance environment file shared by all certhub services.

.. envfile:: /etc/certhub/certhub-certbot-run.env

   Optional per-service environment file shared by all certhub service
   instances.

.. envfile:: /etc/certhub/%i.certhub-certbot-run.env

   Optional per-instance and per-service environment file.


See Also
--------

:manpage:`certhub-cert-expiry@.service`,
:manpage:`certhub-certbot-run(1)`,
:manpage:`certhub-message-format(1)`
