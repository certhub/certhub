certhub-cert-send@.service
==========================

Synopsis
--------

**certhub-cert-send@.service**

**certhub-cert-send@.path**


Description
-----------

A service which a sends certificate to predefined destinations. The specified
command line is executed once for each destination with the certificate piped
to stdin.

A path unit which runs the service unit whenever the exported certificate has
changed on the filesystem.

The instance name (systemd instance string specifier ``%i``) is used as the
basename of the configuration and the certificate file.


Environment
-----------

.. envvar:: CERTHUB_CERT_SEND_SRC

   Path to the certificate file to be sent. Defaults to:
   ``/var/lib/certhub/certs/%i.fullchain.pem``

.. envvar:: CERTHUB_CERT_SEND_CONFIG

   Path to a file containing destinations for the certificate send service.
   ``/etc/certhub/%i.destinations-send.txt``

.. envvar:: CERTHUB_CERT_SEND_COMMAND

   Command to execute for each predefined destination. Use ``%i`` to reference
   the instance name. The command is run once for each line in the
   ``%i.destinations-send.txt`` config file, the line can be referenced with
   the ``{DESTINATION}}`` placeholder.

   Defaults to: ``mail -s '[Certhub] Issue/renew %i' {DESTINATION}``


Examples
--------

Configuration file (placed in ``/etc/certhub/%i.destinations-send.txt``)
containing one destination to send the certificate to ``root@localhost``
whenever a new one has been exported.

::

    root@localhost


Files
-----

.. envfile:: /etc/certhub/env

   Optional environment file shared by all instances and certhub services.

.. envfile:: /etc/certhub/%i.env

   Optional per-instance environment file shared by all certhub services.

.. envfile:: /etc/certhub/certhub-cert-send.env

   Optional per-service environment file shared by all certhub service
   instances.

.. envfile:: /etc/certhub/%i.certhub-cert-send.env

   Optional per-instance and per-service environment file.


See Also
--------

:manpage:`certhub-cert-export@.service(8)`
