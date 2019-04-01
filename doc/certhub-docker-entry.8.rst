certhub-docker-entry
====================

Synopsis
--------

**/usr/local/lib/git-gau/docker-entry.d/60-certbot-account**

**/usr/local/lib/git-gau/docker-entry.d/60-dehydrated-account**

**/usr/local/lib/git-gau/docker-entry.d/60-lego-account**


Description
-----------

A collection of docker entrypoint scripts called by `git-gau`
:program:`docker-entry` via :program:`run-parts`. Useful to setup preexisting
ACME accounts from data passed into a container by environment variables.

Refer to :manpage:`git-gau-docker-entry(8)` for more information on the
entrypoint scripts shipping with `git-gau`. Note that for common use cases
`GAU_REPO` should point to the certhub certificate repository.


Environment (Certbot)
---------------------

It is recommended to specify :envvar:`CERTHUB_CERTBOT_ACCOUNT_ID`,
:envvar:`CERTHUB_CERTBOT_ACCOUNT_KEY`, :envvar:`CERTHUB_CERTBOT_ACCOUNT_REGR`
and :envvar:`CERTHUB_CERTBOT_ACCOUNT_META` for a production setup. The
remaining variables can be ignored in most situations.

.. envvar:: CERTHUB_CERTBOT_ACCOUNT_KEY

   ACME account private key in JSON format used by certbot. If this variable is
   non-empty, its contents will be written to `private_key.json` in the
   respective accounts directory. Note that either
   :envvar:`CERTHUB_CERTBOT_ACCOUNT_ID` or
   :envvar:`CERTHUB_CERTBOT_ACCOUNT_DIR` is required if this variable is set.

.. envvar:: CERTHUB_CERTBOT_ACCOUNT_REGR

   ACME account registration information in JSON format used by certbot. If
   this variable is non-empty, its contents will be written to `regr.json` in
   the respective accounts directory. Note that either
   :envvar:`CERTHUB_CERTBOT_ACCOUNT_ID` or
   :envvar:`CERTHUB_CERTBOT_ACCOUNT_DIR` is required if this variable is set.

.. envvar:: CERTHUB_CERTBOT_ACCOUNT_META

   ACME account meta information in JSON format used by certbot. If this
   variable is non-empty, its contents will be written to `meta.json` in the
   respective accounts directory. Note that either
   :envvar:`CERTHUB_CERTBOT_ACCOUNT_ID` or
   :envvar:`CERTHUB_CERTBOT_ACCOUNT_DIR` is required if this variable is set.

.. envvar:: CERTHUB_CERTBOT_ACCOUNT_ID

   ACME account id as used by certbot to identify the account in the form of a
   32 character long hex string. This is equivalent to the last component of an
   account directory path.

.. envvar:: CERTHUB_CERTBOT_ACCOUNT_SERVER

   ACME endpoint URL for the given account. Defaults to:
   `https://acme-v02.api.letsencrypt.org/directory`

.. envvar:: CERTHUB_CERTBOT_CONFIG_DIR

   Base directory for certbot configuration. Defaults to: `/etc/letsencrypt`.

.. envvar:: CERTHUB_CERTBOT_ACCOUNT_DIR

   Full path to an accounts directory. Defaults to a value computed from
   :envvar:`CERTHUB_CERTBOT_CONFIG_DIR`,
   :envvar:`CERTHUB_CERTBOT_ACCOUNT_SERVER` and
   :envvar:`CERTHUB_CERTBOT_ACCOUNT_ID`.


Environment (Dehydrated)
------------------------

It is recommended to specify :envvar:`CERTHUB_DEHYDRATED_ACCOUNT_KEY` and
:envvar:`CERTHUB_DEHYDRATED_ACCOUNT_REGR` for a production setup. The
remaining variables can be ignored in most situations.

.. envvar:: CERTHUB_DEHYDRATED_ACCOUNT_KEY

   ACME account private key in PEM format used by dehydrated. If this variable
   is non-empty, its contents will be written to `account_key.pem` in the
   respective accounts directory.

.. envvar:: CERTHUB_DEHYDRATED_ACCOUNT_REGR

   ACME account registration information in JSON format used by dehydrated. If
   this variable is non-empty, its contents will be written to
   `registration_info.json` in the respective accounts directory. Note that
   either :envvar:`CERTHUB_DEHYDRATED_ACCOUNT_ID` or
   :envvar:`CERTHUB_DEHYDRATED_ACCOUNT_DIR` is required if this variable is
   set.

.. envvar:: CERTHUB_DEHYDRATED_ACCOUNT_SERVER

   ACME endpoint URL for the given account. Defaults to:
   `https://acme-v02.api.letsencrypt.org/directory`

.. envvar:: CERTHUB_DEHYDRATED_CONFIG_DIR

   Base directory for dehydrated configuration. Defaults to: `/etc/dehydrated`.

.. envvar:: CERTHUB_DEHYDRATED_ACCOUNT_DIR

   Full path to an accounts directory. Defaults to a value computed from
   :envvar:`CERTHUB_DEHYDRATED_CONFIG_DIR` and
   :envvar:`CERTHUB_DEHYDRATED_ACCOUNT_SERVER`.



Environment (Lego)
------------------

It is recommended to specify :envvar:`CERTHUB_LEGO_ACCOUNT_EMAIL`
:envvar:`CERTHUB_LEGO_ACCOUNT_KEY` and :envvar:`CERTHUB_LEGO_ACCOUNT_CONF` for
a production setup. The remaining variables can be ignored in most situations.

.. envvar:: CERTHUB_LEGO_ACCOUNT_KEY

   ACME account private key in PEM format used by lego. If this variable is
   non-empty, its contents will be written to
   `${CERTHUB_LEGO_ACCOUNT_EMAIL}.key` in the respective accounts directory.
   Note that either :envvar:`CERTHUB_LEGO_ACCOUNT_EMAIL` or
   :envvar:`CERTHUB_LEGO_ACCOUNT_KEY_DIR`/:envvar:`CERTHUB_LEGO_ACCOUNT_KEY_FILE`
   are required if this variable is set.

.. envvar:: CERTHUB_LEGO_ACCOUNT_CONF

   ACME account registration information in JSON format used by lego. If this
   variable is non-empty, its contents will be written to `account.json` in the
   respective accounts directory.  Note that either
   :envvar:`CERTHUB_LEGO_ACCOUNT_EMAIL` or
   :envvar:`CERTHUB_LEGO_ACCOUNT_DIR`/:envvar:`CERTHUB_LEGO_ACCOUNT_CONF_FILE`
   are required if this variable is set.

.. envvar:: CERTHUB_LEGO_ACCOUNT_EMAIL

   ACME account email as used by lego to identify the account.

.. envvar:: CERTHUB_LEGO_ACCOUNT_SERVER

   ACME endpoint URL for the given account. Defaults to:
   `https://acme-v02.api.letsencrypt.org/directory`

.. envvar:: CERTHUB_LEGO_DIR

   Base directory for lego configuration. Defaults to: `${HOME}/.lego`.

.. envvar:: CERTHUB_LEGO_ACCOUNT_DIR

   Full path to an accounts directory. Defaults to a value computed from
   :envvar:`CERTHUB_LEGO_DIR`, :envvar:`CERTHUB_LEGO_ACCOUNT_SERVER` and
   :envvar:`CERTHUB_LEGO_ACCOUNT_EMAIL`.

.. envvar:: CERTHUB_LEGO_ACCOUNT_CONF_FILE

   Full path to an accounts config file. Defaults to a value computed from
   :envvar:`CERTHUB_LEGO_DIR`, :envvar:`CERTHUB_LEGO_ACCOUNT_SERVER` and
   :envvar:`CERTHUB_LEGO_ACCOUNT_EMAIL`.

.. envvar:: CERTHUB_LEGO_ACCOUNT_KEY_DIR

   Full path to an accounts key directory. Defaults to a value computed from
   :envvar:`CERTHUB_LEGO_DIR`, :envvar:`CERTHUB_LEGO_ACCOUNT_SERVER` and
   :envvar:`CERTHUB_LEGO_ACCOUNT_EMAIL`.

.. envvar:: CERTHUB_LEGO_ACCOUNT_KEY_FILE

   Full path to an accounts key file. Defaults to a value computed from
   :envvar:`CERTHUB_LEGO_DIR`, :envvar:`CERTHUB_LEGO_ACCOUNT_SERVER` and
   :envvar:`CERTHUB_LEGO_ACCOUNT_EMAIL`.


See Also
--------

:manpage:`git-gau-docker-entry(8)`,
