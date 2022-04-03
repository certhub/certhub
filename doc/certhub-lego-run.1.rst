certhub-lego-run
================

Synopsis
--------

**certhub-lego-run** <*output-cert-file*> <*input-csr-file*> <*lego-directory*> <*lego*> [*lego-run-args* ...]

**certhub-lego-run-preferred-chain** <*preferred-chain*> <*output-cert-file*> <*input-csr-file*> <*lego-directory*> <*lego*> [*lego-run-args* ...]

Description
-----------

Runs the given :program:`lego` binary with CSR read from ``<input-csr-file>``.
Writes the resulting certificate to the ``<output-cert-file>``.

Note, ``<lego-directory>`` must point to the directory where lego stores
account data and certificates (usually ``$HOME/.lego``).

In order to specify the preferred-chain, use the
``certhub-lego-run-preferred-chain`` binary and specify the CN of the preferred
root certificate as the first argument.

Examples
--------

Run :program:`lego run` with CSR from configuration directory. Resulting
fullchain certificate is committed to the repository.

.. code-block:: shell

    git gau-exec /var/lib/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {}/example.com.fullchain.pem x509 \
    certhub-lego-run {}/example.com.fullchain.pem /etc/certhub/example.com.csr.pem /var/lib/certhub/private/lego \
    lego --accept-tos --email hello@example.com

Run :program:`lego run` with CSR from configuration directory and request a
certificate with the alternate/short Let's Encrypt certificate chain. Resulting
fullchain certificate is committed to the repository.

.. code-block:: shell

    git gau-exec /var/lib/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {}/example.com.fullchain.pem x509 \
    certhub-lego-run-preferred-chain "ISRG Root X1" {}/example.com.fullchain.pem /etc/certhub/example.com.csr.pem /var/lib/certhub/private/lego \
    lego --accept-tos --email hello@example.com


See Also
--------

:manpage:`certhub-message-format(1)`
