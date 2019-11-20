Certificates for Internal Services
==================================

For some sites it is desirable that they do not leak into the surface web.
E.g., staging servers for client projects or internal applications, devices and
appliances. All certificates which are issued by Let's Encrypt are recorded in
the `Certificate Transparency <https://www.certificate-transparency.org/>`__
Logs.

CT Logs are a popular `reconnaissance tool <https://medium.com/@yassineaboukir/automated-monitoring-of-subdomains-for-fun-and-profit-release-of-sublert-634cfc5d7708>`__
among security analysts, since they can be parsed easily with automated tools
on large scale.

In order to prevent leaking information via CT Logs, the following measures are
appropriate: Use wildcard certificates and a separate domain.


Wildcard Certificates
---------------------

Wildcard certificates can be issued for exactly one level of subdomains. E.g.,
a certificate containing the SAN ``*.example.com`` is valid for
``my-crm.example.com`` but neither for ``example.com`` nor for
``crm.apps.example.com``.

Thus it is recommended to plan with a flat subdomain structure, especially if
subdomains are to be generated in an automated way.

Note that there is no need to reuse one pair of key/certificate for all
services. It is completely possible to issue and deploy distinct certificates
for the same wildcard domain to different hosts, as long as the
`rate limits <https://letsencrypt.org/docs/rate-limits/>`__ are adhered to.


Separate Domain
---------------

Instead of using the main domain which is known to the general public, a
dedicated domain can be registered and used for internal purposes. This also
simplifies setup of DNS ``CAA`` records. E.g., the ``CAA`` on a dedicated
domain can be restricted to wildcard certificates only.
