certhub-cert-expiry
===================

Synopsis
--------

**certhub-cert-expiry** <*input-cert-file*> <*seconds*> <*command*> [*args* ...]


Description
-----------

If the given certificate is about to expire in the given amount of
seconds, run the command.

Common values for the ttl parameter:

86400
    Twenty four hours.
604800
    7 days.
2592000
    30 days.


Examples
--------

Run :program:`certhub-cert-expiry` with certificate read from the repository.
Format a message containing information about the certificate and write it to
the status file if its expiration date is within 30 days.

.. code-block:: shell

    git gau-exec /var/lib/certhub/certs.git \
    git gau-xargs -I{} \
    certhub-status-file /var/lib/certhub/status/example.com.expiry.status
    certhub-cert-expiry "{}/example.com.fullchain.pem" 2592000 \
    certhub-message-format "{}/example.com.fullchain.pem" x509 \
    echo "Certificate will expire within 30 days"


See Also
--------

:manpage:`certhub-status-file(1)`
