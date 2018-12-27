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


See Also
--------

:manpage:`lexicon(1)`,
