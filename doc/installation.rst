Installation
============

Dependencies
------------

The executables provided by certhub only depend on ``openssl`` and any of the
following supported ACME clients: Certbot_, Dehydrated_ or Lego_. Certhub
includes DNS-01 challenge hooks for ``nsupdate`` and Lexicon_.

In order to use the systemd units, ``git`` and git-gau_ is required.

Install
-------

Navigate to the Certhub releases_ page and pick the latest
``certhub-dist.tar.gz`` tarball. Copy it to the target machine and unpack it
there.

.. code-block:: shell

    $ scp dist/certhub-dist.tar.gz me@example.com:~
    $ ssh me@example.com sudo tar -C /usr/local -xzf ~/certhub-dist.tar.gz

Alternatively use the following ansible task to copy and unarchive a dist
tarball into `/usr/local`. Note that git-gau_ can be installed in the same way.

.. code-block:: yaml

    - name: Certhub present
      notify: Systemd reloaded
      unarchive:
        src: files/certhub-dist.tar.gz
        dest: /usr/local

.. _releases: https://github.com/znerol/certhub/releases/
.. _Certbot: https://certbot.eff.org/
.. _Dehydrated: https://dehydrated.io/
.. _Lego: https://github.com/go-acme/lego
.. _Lexicon: https://github.com/AnalogJ/lexicon
.. _git-gau: https://github.com/znerol/git-gau
