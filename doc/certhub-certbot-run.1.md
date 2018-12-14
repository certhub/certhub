% certhub-certbot-run(1) Certhub User Manuals
% Lorenz Schori
% November 30, 2018

# NAME

certhub-certbot-run - Runs certbot certonly command once

# SYNOPSIS

certhub-certbot-run output-cert-file input-csr-file certbot [certbot-certonly-args...]

# DESCRIPTION

Runs the given *certbot* binary with CSR read from input-csr-file. Writes
the resulting certificate to the output-cert-file as well.

# EXAMPLES

Run *certbot certonly* with CSR read from the repository. Resulting fullchain
certificate is committed to the repository as well.

    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {}/example.com.fullchain.pem x509 \
    certhub-certbot-run {}/example.com.fullchain.pem {}/example.com/csr.pem \
    certbot --config /home/certhub/config/example.com.certbot.ini

# SEE ALSO

`certbot` (1).
`certhub-message-format` (1).
