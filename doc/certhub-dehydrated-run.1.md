% certhub-dehydrated-run(1) Certhub User Manuals
% Lorenz Schori
% November 30, 2018

# NAME

certhub-dehydrated-run - Runs dehydrated --signcsr command once

# SYNOPSIS

certhub-dehydrated-run output-cert-file input-csr-file dehydrated [dehydrated-args...]

# DESCRIPTION

Runs the given *dehydrated* binary with CSR read from input-csr-file. Writes
the resulting certificate to the output-cert-file as well.

# EXAMPLES

Run *dehydrated certonly* with CSR read from the repository. Resulting fullchain
certificate is committed to the repository as well.

    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {}/example.com/fullchain.pem x509 \
    certhub-dehydrated-run {}/example.com/fullchain.pem {}/example.com/csr.pem \
    dehydrated --config /home/certhub/config/example.com.dehydrated

# SEE ALSO

`certbot` (1).
`certhub-message-format` (1).
