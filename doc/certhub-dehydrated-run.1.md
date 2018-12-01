% certhub-dehydrated-run(1) Certhub User Manuals
% Lorenz Schori
% November 30, 2018

# NAME

certhub-dehydrated-run - Runs dehydrated --signcsr command once

# SYNOPSIS

certhub-dehydrated-run instance-directory dehydrated [dehydrated-args...]

# DESCRIPTION

Runs the given *dehydrated* binary with CSR read from instance-directory. Writes
the resulting certificate to the instance-directory as well.

# EXAMPLES

Run *dehydrated certonly* with CSR read from the repository. Resulting fullchain
certificate is committed to the repository as well.

    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {}/example.com \
    certhub-dehydrated-run {}/example.com \
    dehydrated --config /home/certhub/config/example.com.dehydrated

# VARIABLES

CERTHUB\_CSR\_NAME
:   Specify the filename used for the CSR inside the repository. Defaults to
    *csr.pem*.

CERTHUB\_FULLCHAIN\_NAME
:   Specify the filename used for the certificate inside the repository.
    Defaults to *fullchain.pem*.

# SEE ALSO

`certbot` (1).
`certhub-message-format` (1).
