certhub-cert-reload@.service
============================

Synopsis
--------

**certhub-cert-reload@.service**

**certhub-cert-reload@.path**


Description
-----------

A service which reloads specified tls servers.

A path unit which runs the service unit whenever the exported certificate has
changed on the filesystem.

The instance name (systemd instance string specifier ``%i``) is used as the
basename of the configuration and the certificate file.


Environment
-----------

.. envvar:: CERTHUB_CERT_RELOAD_CONFIG

   Path to a file containing the services to reload. Defaults to:
   ``/etc/certhub/%i.services-reload.txt``


Files
-----

.. envfile:: /etc/certhub/env

   Optional environment file shared by all instances and certhub services.

.. envfile:: /etc/certhub/%i.env

   Optional per-instance environment file shared by all certhub services.

.. envfile:: /etc/certhub/certhub-cert-reload.env

   Optional per-service environment file shared by all certhub service
   instances.

.. envfile:: /etc/certhub/%i.certhub-cert-reload.env

   Optional per-instance and per-service environment file.


See Also
--------

:manpage:`certhub-cert-export@.service(8)`
