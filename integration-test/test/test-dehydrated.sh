#!/bin/sh

set -e
set -u
set -x

STATUS=1

su -s /bin/sh -c "dehydrated --register --accept-terms --config /home/certhub/config/dehydrated-test.dehydrated" - certhub
if systemctl start certhub-dehydrated-run@dehydrated-test.service; then
    STATUS=0
fi
journalctl -u certhub-dehydrated-run@dehydrated-test.service

exit ${STATUS}
