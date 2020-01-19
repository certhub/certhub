Generating TLS Keys and Signing Requests
========================================

Use a trustworthy machine with good entropy to generate TLS keys.

RSA Keys
--------

`SSL Labs recommends <https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices>`__ 
a key size of 2048 bits for most use cases. They discourage usage of keys
bigger than 3072 bits. Use the following command to generate RSA keys with
``openssl``.

.. code-block:: shell

    # 2048 bit RSA
    $ openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out example-rsa.key.pem

    # 3072 bit RSA
    $ openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out example-rsa.key.pem

ECDSA Keys
----------

Most `browsers support <https://www.ssllabs.com/ssltest/clients.html>`__
``secp256r1 (P-256)`` and ``secp384r1 (P-384)`` curves. Use the following
command to generate EC keys with ``openssl``:

.. code-block:: shell

    # P-256 EC key
    $ openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out example-ec.key.pem

    # P-384 EC key
    $ openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-384 -out example-ec.key.pem

Certificate Signing Request
---------------------------

The openssl ``req`` utility can be used to generate certificate signing
requests suitable for ``certhub``. Note that *Let's Encrypt* ignores anything
in the CSR except ``CN``, ``subjectAltName`` and the OCSP stapling tls feature
flag if present. Adapt the following example to generate a CSR from the command
line without having to craft a openssl.cnf file.

.. code-block:: shell

   $ openssl req -new -subj "/CN=example.com" \
         -addext "subjectAltName = DNS:example.com,DNS:www.example.com" \
         -addext "basicConstraints = CA:FALSE" \
         -addext "keyUsage = nonRepudiation, digitalSignature, keyEncipherment" \
         -addext "tlsfeature = status_request" \ # Remove this line if your TLS server is not configured for OCSP.
         -key example-ec.key.pem -out example-ec.csr.pem

In order to inspect any CSR, use the ``-text`` and ``-noout`` flags:


.. code-block:: shell

   $ openssl req -text -noout -in example-ec.csr.pem
