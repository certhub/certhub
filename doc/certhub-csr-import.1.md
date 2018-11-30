% certhub-csr-import(1) Certhub User Manuals
% Lorenz Schori
% November 30, 2018

# NAME

certhub-csr-import - Move the given CSR file to the certificate instance directory.

# SYNOPSIS

certhub-csr-import instance-directory csr.pem [ssl.cnf]"

# DESCRIPTION

Moves a CSR file and optionally also the corresponding openssl configuration
file to the given instance directory. The instance directory is created if
necessary.

Use this command in combination with *certhub-format-message* and
*git-gau-exec* / *git-gau-ac* in order to add certificate requests to the
certhub repository.

# EXAMPLES

Import CSR and openssl configuration file into the certhub repository.

    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {}/example.com \
    certhub-csr-import {}/example.com /path/to/csr.pem /path/to/ssl.cnf

# VARIABLES

CERTHUB\_CSR\_NAME
:   Specify the filename used for the CSR inside the repository. Defaults to
    *csr.pem*.

CERTHUB\_CNF\_NAME
:   Specify the filename used for the openssl config inside the repository.
    Defaults to *ssl.cnf*.

# SEE ALSO

`certhub-message-format` (1).
