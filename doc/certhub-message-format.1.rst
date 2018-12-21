certhub-message-format
======================

Synopsis
--------

**certhub-message-format** <*input-pem-file*> [*x509|req*] <*command*> [*args* ...]


Description
-----------

Runs the specified ``<command>`` and capture its standard output and standard
error.  Formats the output in a way which suites :program:`git-commit` /
:program:`git-gau-ac`. Also attaches CSR or certificate details if the
specified ``<input-pem-file>`` exists.

Use this command in combination with :program:`certhub-certbot-run` and
:program:`git-gau-exec` / :program:`git-gau-ac` when adding / renewing
certificates in an automated way.


Environment
-----------

.. envvar:: CERTHUB_MESSAGE_SUBJECT

   First line of the message. By default this is generated
   automatically.

.. envvar:: CERTHUB_MESSAGE_SUBJECT_PREFIX

   Message prefix when automated subject generation is enabled.
   Defaults to ``[Certhub]``.

.. envvar:: CERTHUB_MESSAGE_SUBJECT_ACTION

   Message action name when automated subject generation is enabled.
   Defaults to basename of executed command.

.. envvar:: CERTHUB_MESSAGE_CSR_TEXTOPTS

   Output options as understood by :program:`openssl req`. Defaults to:
   ``--noout -text -reqopt no_pubkey,no_sigdump``

.. envvar:: CERTHUB_MESSAGE_CERT_TEXTOPTS

    Output options as understood by :program:`openssl x509`. Defaults to:
    ``--noout -text -certopt no_pubkey,no_sigdump,no_extensions -sha256
    -fingerprint``


See Also
--------

:manpage:`certhub-certbot-run(1)`
