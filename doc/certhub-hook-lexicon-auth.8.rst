certhub-hook-lexicon-auth
=========================

Synopsis
--------

**/usr/local/lib/certhub/certbot-hooks/hook-lexicon-auth**

**/usr/local/lib/certhub/certbot-hooks/hook-lexicon-cleanup**

**/usr/local/lib/certhub/dehydrated-hooks/hook-lexicon-auth**


Description
-----------

A hook script for :program:`certbot` and :program:`dehydrated` respectively
capable of deploying DNS-01 challenge tokens via :program:`lexicon`.


Environment
-----------

.. envvar:: CERTHUB_LEXICON_PROVIDER

   Specify the domain provider which hosts the zone to be used in the DNS
   challenge.

.. envvar:: CERTHUB_LEXICON_CREATE_EXIT_DELAY

   Optional delay in seconds after record creation (defaults to 5):

.. envvar:: CERTHUB_LEXICON_GLOBAL_ARGS

   Optional additional global lexicon arguments: see :manpage:`lexicon(1)` for
   more information.

.. envvar:: CERTHUB_LEXICON_PROVIDER_ARGS

   Optional additional lexicon provider arguments (e.g. logging): see
   :manpage:`lexicon(1)` for more information.

.. envvar:: CERTHUB_LEXICON_DOMAIN

   Domain name passed to lexicon to use for the challenge. Defaults to
   ${domain-to-be-validated}. Customizing this setting makes sense, e.g. when
   using ``CNAME`` records to redirect _acme-challenge names from the real
   domain to a separate zone purpose built for challange validation.

.. envvar:: CERTHUB_LEXICON_NAME

   Record name to use for the challenge. Defaults to
   ``_acme-challenge.${CERTHUB_LEXICON_DOMAIN}``. Customizing this setting
   makes sense, e.g. when using ``CNAME`` records to redirect _acme-challenge
   names from the real domain to a separate zone purpose built for challange
   validation.


See Also
--------

:manpage:`lexicon(1)`,
