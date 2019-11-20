DNS Zone Setup
==============

When using `DNS-01 <https://letsencrypt.org/docs/challenge-types/#dns-01-challenge>`__
the *ACME Client* requires access to create and delete ``TXT`` records on the
``_acme-challenge`` subdomain of the target domain. In order to reduce risk of
compromise of the main DNS zone, it is necessary to serve challenges from a
different DNS zone with separate credentials, or even a dedicated DNS server.

In order to serve the challenge from a different zone, it is necessary to
either **delegate** the ``_acme-challenge`` subdomain to another DNS server
using ``NS`` records or to **alias** the subdomain into a dedicated zone using
``CNAME`` records.


Example setup
-------------

Services in the following domains should be protected using Let's Encrypt
certificates: ``www.example.com``, ``example.com``.

Note, many public DNS providers do only support privilege separation on a
per-domain level. Thus subdomains cannot be managed from a different account.
In this case it is recommended to simply host challenge zones using a different
public DNS provider. It is recommended to choose one which is supported well by
the *ACME Client* in use.

As an alternative to public DNS providers, there is the option to run a
dedicated stripped down non-recursive DNS server only hosting challenge zones.


Delegation
----------

Assuming that a dedicated DNS service reachable at ``acme-ns1.example.net`` is
hosting ``_acme-challenge`` zones. The service needs to host one
``_acme-challenge`` zone for each target domain. Thus if a certificate should
be requested containing ``example.com`` and ``www.example.com``, then the DNS
service needs to host two zones. I.e., ``_acme-challenge.example.com`` and
``_acme-challenge.www.example.com``.

In that case the following DNS records need to be added to the main zone:

::

   _acme-challenge.www.example.com. IN NS acme-ns1.example.net
   _acme-challenge.example.com.     IN NS acme-ns1.example.net


Aliasing
--------

Assuming that there is a DNS zone ``auth.example.net`` dedicated to host ACME
challenges. One or more DNS label(s) needs to be choosen in the dedicated DNS
zone to host the ``TXT`` records. Note that there is no strict rule on how
labels need to be named. In general it is recommended that records in a label
are only updated by one *ACME client* at a time.

The following DNS records need to be added to the main zone if the label
``www-example-com`` should be used to serve ``TXT`` records inside
``auth.example.com``.

::

   _acme-challenge.www.example.com. IN CNAME www-example-com.auth.example.com
   _acme-challenge.example.com.     IN CNAME www-example-com.auth.example.com

Note: Some *ACME clients* require advanced configuration to support ``CNAME``
records. Otherwise they will attempt to update records on the main zone.


Further Reading
---------------

See also:

* `EFF - A Technical Deep Dive: Securing the Automation of ACME DNS Challenge Validation <https://www.eff.org/deeplinks/2018/02/technical-deep-dive-securing-automation-acme-dns-challenge-validation>`__
* `GitHub - joohoi/acme-dns <https://github.com/joohoi/acme-dns/>`__
