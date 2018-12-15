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

Run *dehydrated --signcsr* with CSR from the configuration directory. Resulting
fullchain certificate is committed to the repository.

    git gau-exec /var/lib/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {}/example.com.fullchain.pem x509 \
    certhub-dehydrated-run {}/example.com.fullchain.pem /etc/certhub/example.com.csr.pem \
    dehydrated --config /etc/certhub/example.com.dehydrated.conf

# SEE ALSO

`dehydrated` (1).
`certhub-message-format` (1).
