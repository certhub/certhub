% certhub-lego-run(1) Certhub User Manuals
% Lorenz Schori
% November 30, 2018

# NAME

certhub-lego-run - Runs lego run command once

# SYNOPSIS

certhub-lego-run output-cert-file input-csr-file lego-directory lego [lego-run-args...]

# DESCRIPTION

Runs the given *lego* binary with CSR read from input-csr-file. Writes
the resulting certificate to the output-cert-file as well.

Note, *lego-directory* must point to the directory where lego stores account
data and certificates (usually $HOME/.lego).

# EXAMPLES

Run *lego run* with CSR read from the repository. Resulting fullchain
certificate is committed to the repository as well.

    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    xargs -a /home/certhub/config/example.com.lego.ini
    certhub-message-format {}/example.com.fullchain.pem x509 \
    certhub-lego-run {}/example.com.fullchain.pem {}/example.com/csr.pem /home/certhub/lego \
    lego

# SEE ALSO

`certhub-message-format` (1).
