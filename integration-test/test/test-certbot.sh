#!/bin/sh

set -e
set -u
set -x

STATUS=1

/bin/su -s /bin/sh -c "/home/certhub/setup/csr-import.sh  /home/certhub/setup/certbot-test" - certhub
if /bin/systemctl start certhub-certbot-run@certbot-test.service; then
    STATUS=0
fi
/bin/journalctl -u certhub-certbot-run@certbot-test.service

exit ${STATUS}
