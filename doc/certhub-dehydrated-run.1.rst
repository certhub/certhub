certhub-dehydrated-run
======================

Synopsis
--------

**certhub-dehydrated-run** <*output-cert-file*> <*input-csr-file*> <*dehydrated*> [*dehydrated-args* ...]


Description
-----------

Runs the given :program:`dehydrated` binary with CSR read from
``<input-csr-file>`` Writes the resulting certificate to the
``<output-cert-file>``.


Examples
--------

Run :program:`dehydrated --signcsr` with CSR from the configuration directory.
Resulting fullchain certificate is committed to the repository.

.. code-block:: shell

    git gau-exec /var/lib/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {}/example.com.fullchain.pem x509 \
    certhub-dehydrated-run {}/example.com.fullchain.pem /etc/certhub/example.com.csr.pem \
    dehydrated --config /etc/certhub/example.com.dehydrated.conf


See Also
--------

:manpage:`dehydrated(1)`, :manpage:`certhub-message-format(1)`
