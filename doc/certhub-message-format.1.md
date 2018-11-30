% certhub-message-format(1) Certhub User Manuals
% Lorenz Schori
% November 30, 2018

# NAME

certhub-message-format - Run a command and format its output.

# SYNOPSIS

certhub-message-format instance-directory command [args...]

# DESCRIPTION

Rens the specified command and capture its standard output and standard error.
Formats the output in a way which suites *git-commit*. Also attaches CSR and
certificate details if such files are found in the specified instance
directory.

Use this command in combination with *certhub-csr-import* or
*certhub-certbot-run* and *git-gau-exec* / *git-gau-ac* when adding / renewing
certificates in an automated way.


# VARIABLES

CERTHUB\_MESSAGE\_SUBJECT
:   First line of the message. By default this is generated automatically.

CERTHUB\_MESSAGE\_SUBJECT\_PREFIX
:   Message prefix when automated subject generation is enabled. Defaults to
    [Certhub].

CERTHUB\_MESSAGE\_ACTION\_NAME
:   Message action name when automated subject generation is enabled. Defaults
    to basename of executed command.

CERTHUB\_MESSAGE\_INSTANCE\_NAME
:   Instance name when automated subject generation is enabled. Defaults
    to basename of given instance directory.

CERTHUB\_CSR\_NAME
:   Specify the filename used for the CSR inside the repository. Defaults to
    *csr.pem*.

CERTHUB\_FULLCHAIN\_NAME
:   Specify the filename used for the certificate inside the repository.
    Defaults to *fillchain.pem*.

CERTHUB\_REQ\_LOGOPTS
:   Output options as understood by *openssl req*. Defaults to: --noout -text
    -reqopt no\_pubkey,no\_sigdump

CERTHUB\_CERT\_LOGOPTS
:   Output options as understood by *openssl x509*. Defaults to: --noout -text
    -certopt no\_pubkey,no\_sigdump,no\_extensions -sha256 -fingerprint


# SEE ALSO

`certhub-csr-import` (1).
