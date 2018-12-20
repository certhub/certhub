certhub-lego-run
================

Synopsis
--------

**certhub-lego-run** <*output-cert-file*> <*input-csr-file*> <*lego-directory*> <*lego*> [*lego-run-args* ...]


Description
-----------

Runs the given :program:`lego` binary with CSR read from ``<input-csr-file>``.
Writes the resulting certificate to the ``<output-cert-file>``.

Note, ``<lego-directory>`` must point to the directory where lego stores
account data and certificates (usually ``$HOME/.lego``).


Examples
--------

Run :program:`lego run` with CSR from configuration directory. Resulting
fullchain certificate is committed to the repository.

.. code-block:: shell

    git gau-exec /var/lib/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    xargs -a /etc/certhub/example.com.lego.args
    certhub-message-format {}/example.com.fullchain.pem x509 \
    certhub-lego-run {}/example.com.fullchain.pem /etc/certhub/example.com.csr.pem /var/lib/certhub/private/lego \
    lego


See Also
--------

:manpage:`certhub-message-format(1)`
