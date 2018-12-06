#!/bin/sh

set -e
set -u
set -x

STATUS=1

yum install -y nmap-ncat

if env | grep PROXY; then
    while ! nc 127.0.0.1 9050 < /dev/null ; do
        sleep 1
        continue
    done
    curl http://checkip.dyndns.org/
    curl http://checkip.dyndns.org/
    curl http://checkip.dyndns.org/
fi

su -s /bin/sh -c "/home/certhub/setup/csr-import.sh /home/certhub/setup/dehydrated-test" - certhub
su -s /bin/sh -c "dehydrated --register --accept-terms --config /home/certhub/config/dehydrated-test.dehydrated" - certhub
if systemctl start certhub-dehydrated-run@dehydrated-test.service; then
    STATUS=0
fi
journalctl -u certhub-dehydrated-run@dehydrated-test.service

exit ${STATUS}
