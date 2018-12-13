% certhub-status-file(1) Certhub User Manuals
% Lorenz Schori
% November 30, 2018

# NAME

certhub-status-file - Write a status file with content from a command

# SYNOPSIS

certhub-status-file output-status-file command [args...]

# DESCRIPTION

Runs the specified command and capture its standard output. Writes the output
to the specified status file. Removes the status file if command doesn't output
anything.

Use this command in combination with *certhub-cert-expiry* in order to flag
certificates which are about to expire.

# SEE ALSO

`certhub-cert-expiry` (1).
