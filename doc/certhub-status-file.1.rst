certhub-status-file
===================

Synopsis
--------

**certhub-status-file** <*output-status-file*> <*command*> [*args* ...]

Description
-----------

Runs the specified ``<command>`` and capture its standard output. Writes the
output to the specified status file. Removes the status file if command doesn't
output anything.

Use this command in combination with :program:`certhub-cert-expiry` in order to
flag certificates which are about to expire.


See Also
--------

:manpage:`certhub-cert-expiry(1)`
