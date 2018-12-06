% certhub-lego-run(1) Certhub User Manuals
% Lorenz Schori
% November 30, 2018

# NAME

certhub-lego-run - Runs lego run command once

# SYNOPSIS

certhub-lego-run instance-directory lego-directory lego [lego-run-args...]

# DESCRIPTION

Runs the given *lego* binary with CSR read from instance-directory. Writes
the resulting certificate to the instance-directory as well.

Note, *lego-directory* must point to the directory where lego stores account
data and certificates (usually $HOME/.lego).

# EXAMPLES

Run *lego run* with CSR read from the repository. Resulting fullchain
certificate is committed to the repository as well.

    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    xargs -a /home/certhub/config/example.com.lego.ini
    certhub-message-format {}/example.com \
    certhub-lego-run {}/example.com /home/certhub/lego \
    lego

# VARIABLES

CERTHUB\_CSR\_NAME
:   Specify the filename used for the CSR inside the repository. Defaults to
    *csr.pem*.

CERTHUB\_FULLCHAIN\_NAME
:   Specify the filename used for the certificate inside the repository.
    Defaults to *fullchain.pem*.

# SEE ALSO

`certhub-message-format` (1).
