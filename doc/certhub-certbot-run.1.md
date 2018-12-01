% certhub-certbot-run(1) Certhub User Manuals
% Lorenz Schori
% November 30, 2018

# NAME

certhub-certbot-run - Runs certbot certonly command once

# SYNOPSIS

certhub-certbot-run instance-directory certbot [certbot-certonly-args...]

# DESCRIPTION

Runs the given *certbot* binary with CSR read from instance-directory. Writes
the resulting certificate to the instance-directory as well.

# EXAMPLES

Run *certbot certonly* with CSR read from the repository. Resulting fullchain
certificate is committed to the repository as well.

    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {}/example.com \
    certhub-certbot-run {}/example.com \
    certbot --config /home/certhub/config/example.com.certbot.ini

# VARIABLES

CERTHUB\_CSR\_NAME
:   Specify the filename used for the CSR inside the repository. Defaults to
    *csr.pem*.

CERTHUB\_FULLCHAIN\_NAME
:   Specify the filename used for the certificate inside the repository.
    Defaults to *fullchain.pem*.

# SEE ALSO

`dehydrated` (1).
`certhub-message-format` (1).
