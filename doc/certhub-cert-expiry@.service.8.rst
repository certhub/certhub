certhub-cert-expiry@.service
============================

Synopsis
--------

**certhub-cert-expiry@.service**


Description
-----------

A service which checks validity of a certificate read from the repository.
Formats a message and writes it to a status file if the respective certificate
is about to expire.

The instance name (systemd instance string specifier ``%i``) is used as the
basename of the certificate file and the resulting status message.


Environment
-----------

.. envvar:: CERTHUB_REPO

   URL of the repository where certificates are stored. Defaults to:
   ``/var/lib/certhub/certs.git``

.. envvar:: CERTHUB_CERT_PATH

   Path to the certificate file inside the repository. Defaults to:
   ``{WORKDIR}/%i.fullchain.pem``

.. envvar:: CERTHUB_CERT_EXPIRY_TTL

   See manpage:`certhub-cert-expiry(1)`, defaults to 30 days in seconds, i.e. ``2592000``

.. envvar:: CERTHUB_CERT_EXPIRY_MESSAGE

   Message written to the status file if certificate is about to expire. Defaults to
   ``Certificate will expire within 30 days``

.. envvar:: CERTHUB_CERT_EXPIRY_STATUSFILE:

   Location of status file written if a certificate is about to expire. Defaults to:
   ``/var/lib/certhub/status/%i.expiry.status``


See Also
--------

:manpage:`certhub-cert-expiry(1)`, :manpage:`certhub-format-message(1)`,
:manpage:`certhub-status-file(1)`
