#!/bin/sh

set -e
set -u
set -x

STATUS=1

if env | grep PROXY; then
    curl http://checkip.dyndns.org/
    curl http://checkip.dyndns.org/
    curl http://checkip.dyndns.org/
fi

/bin/su -s /bin/sh -c "/home/certhub/setup/csr-import.sh  /home/certhub/setup/lego-test" - certhub
if /bin/systemctl start certhub-lego-run@lego-test.service; then
    STATUS=0
fi
/bin/journalctl -u certhub-lego-run@lego-test.service

exit ${STATUS}
