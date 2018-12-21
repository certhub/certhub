certhub-lego-run@.service
============================

Synopsis
--------

**certhub-lego-run@.service**

**certhub-lego-run@.path**


Description
-----------

A service which runs :program:`certhub-lego-run` with a CSR read from the
config directory. The resulting fullchain certificate is committed to the
repository. A commit message is generated automatically.

A path unit which runs the service unit if the expiry status file managed by
:program:`certhub-cert-expiry@.service` exists.

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

.. envvar:: CERTHUB_LEGO_ARGS

   Additional Arguments for :program:`lego --csr` run. Empty by default.

.. envvar:: CERTHUB_LEGO_CHALLENGE_ARGS

   Use this environment variable to select a challenge method. Empty by
   default. Lego will fall back to HTTP-01 challenge if this variable is not
   set.

.. envvar:: CERTHUB_LEGO_CONFIG

   Path to a file with additional lego cli arguments. Defaults to:
   ``/etc/certhub/%i.lego.args``

.. envvar:: CERTHUB_LEGO_DIR

   The path to the directory where lego stores accound data and issued
   certificates. Defaults to: ``var/lib/certhub/private/lego``


See Also
--------

:manpage:`certhub-cert-expiry@.service`,
:manpage:`certhub-lego-run(1)`,
:manpage:`certhub-message-format(1)`
