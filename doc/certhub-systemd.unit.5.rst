certhub-systemd.unit
====================


Synopsis
--------

**name.certbot**, **name.lego**, **name.dehydrated**, **name.push**,
**destination.send**, **name.cert**


Description
-----------

Collects certhub unit files from `/etc/certhub/systemd` and generates systemd
timer and path unit instances from them.


Environment
-----------

.. envvar:: CERTHUB_UNIT_DIR

   Only specify for testing purposes.
