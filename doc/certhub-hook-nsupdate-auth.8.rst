certhub-hook-nsupdate-auth
==========================

Synopsis
--------

**/usr/local/lib/certhub/certbot-hooks/hook-nsupdate-auth**

**/usr/local/lib/certhub/certbot-hooks/hook-nsupdate-cleanup**

**/usr/local/lib/certhub/dehydrated-hooks/hook-nsupdate-auth**


Description
-----------

A hook script for :program:`certbot` and :program:`dehydrated` respectively
capable of deploying DNS-01 challenge tokens via :program:`nsupdate`.


Environment
-----------

.. envvar:: CERTHUB_NSUPDATE_ARGS

   Arguments passed to nsupdate called from auth/cleanup hooks. Specify the
   path to the DDNS key used to update a DNS zone. Example:
   ``CERTHUB_NSUPDATE_ARGS=-k /etc/certhub/example.com.nsupdate.key``

.. envvar:: CERTHUB_NSUPDATE_SERVER

   Contact the specified server. By default nsupdate queries SOA records in
   order to determine the authoritative server. Example:
   ``CERTHUB_NSUPDATE_SERVER=some-ns.example.com``

.. envvar:: CERTHUB_NSUPDATE_TTL

   TTL for created DNS records. Defaults to 600.

.. envvar:: CERTHUB_NSUPDATE_DOMAIN

   Domain name to use for the challenge. Uses
   ``_acme-challenge.${domain-to-be-validated}`` by default. Customizing this
   setting makes sense, e.g. when using ``CNAME`` records to redirect
   _acme-challenge names from the real domain to a separate zone purpose built
   for challange validation.


See Also
--------

:manpage:`nsupdate(1)`,
