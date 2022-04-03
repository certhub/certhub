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

.. envvar:: CERTHUB_LEGO_ARGS

   Additional Arguments for :program:`lego --csr` run. Empty by default.

.. envvar:: CERTHUB_LEGO_PREFERRED_CHAIN

   Set the preferred certificate chain. If the CA offers multiple certificate
   chains, prefer the chain whose topmost certificate was issued from this
   Subject Common Name. If no match, the default offered chain will be used.
   Empty by default.

   Specify ``CERTHUB_LEGO_PREFERRED_CHAIN=ISRG Root X1`` in one of the envfiles
   listed in the next section to use the alternate/short Let's Encrypt chain.

.. envvar:: CERTHUB_LEGO_CHALLENGE_ARGS

   Use this environment variable to select a challenge method. Empty by
   default. Lego will fall back to HTTP-01 challenge if this variable is not
   set.

.. envvar:: CERTHUB_LEGO_DIR

   The path to the directory where lego stores accound data and issued
   certificates. Defaults to: ``var/lib/certhub/private/lego``


Files
-----

.. envfile:: /etc/certhub/env

   Optional environment file shared by all instances and certhub services.

.. envfile:: /etc/certhub/%i.env

   Optional per-instance environment file shared by all certhub services.

.. envfile:: /etc/certhub/certhub-lego-run.env

   Optional per-service environment file shared by all certhub service
   instances.

.. envfile:: /etc/certhub/%i.certhub-lego-run.env

   Optional per-instance and per-service environment file.


See Also
--------

:manpage:`certhub-cert-expiry@.service`,
:manpage:`certhub-lego-run(1)`,
:manpage:`certhub-message-format(1)`
