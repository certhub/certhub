#!/bin/sh

set -e
set -u
set -x

STATUS=1

if /bin/systemctl start certhub-certbot-run@certbot-test.service; then
    STATUS=0
fi
/bin/journalctl -u certhub-certbot-run@certbot-test.service

exit ${STATUS}
