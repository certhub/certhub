#!/bin/sh

set -e
set -u
set -x

STATUS=1

env | grep PROXY
curl https://ifconfig.co/
curl https://ifconfig.co/
curl https://ifconfig.co/

su -s /bin/sh -c "/home/certhub/setup/csr-import.sh /home/certhub/setup/dehydrated-test" - certhub
su -s /bin/sh -c "dehydrated --register --accept-terms --config /home/certhub/config/dehydrated-test.dehydrated" - certhub
if systemctl start certhub-dehydrated-run@dehydrated-test.service; then
    STATUS=0
fi
journalctl -u certhub-dehydrated-run@dehydrated-test.service

exit ${STATUS}
