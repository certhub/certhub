certhub-repo-push@.service
==========================

Synopsis
--------

**certhub-repo-push@.service**


Description
-----------

A service which pushes the certhub repository to another host.

The unescaped instance name (systemd unescaped instance string specifier
``%I``) is used as the URL for the remote repository. Note that the instance
name likely needs to be escaped using :program:`systemd-escape --template`.


Environment
-----------

.. envvar:: CERTHUB_REPO

   URL of the repository where certificates are stored. Defaults to:
   ``/var/lib/certhub/certs.git``

.. envvar:: CERTHUB_REPO_PUSH_REMOTE

   URL of the remote repository. Defaults to:
   ``CERTHUB_REPO_PUSH_REMOTE=%I``

.. envvar:: CERTHUB_REPO_PUSH_ARGS

   Arguments to the git push command. Defaults to:
   ``--mirror``

.. envvar::  CERTHUB_REPO_PUSH_REFSPEC

   Refspec for the git push command. Empty by default.


See Also
--------

:manpage:`git-push(1)`
