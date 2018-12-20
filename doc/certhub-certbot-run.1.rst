certhub-certbot-run
===================

Synopsis
--------

**certhub-certbot-run** <*output-cert-file*> <*input-csr-file*> <*certbot*> [*certbot-certonly-args* ...]


Description
-----------

Runs the given :program:`certbot` binary with CSR read from
``<input-csr-file>``.  Writes the resulting certificate to the
``<output-cert-file>`` as well.


Examples
--------

Run :program:`certbot certonly` with CSR from the configuration directory.
Resulting fullchain certificate is committed to the repository.

.. code-block:: shell

    git gau-exec /var/lib/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {}/example.com.fullchain.pem x509 \
    certhub-certbot-run {}/example.com.fullchain.pem /etc/certhub/example.com.csr.pem \
    certbot --config /etc/certhub/example.com.certbot.ini


See Also
--------

:manpage:`certbot(1)`, :manpage:`certhub-message-format(1)`
