#!/bin/sh

set -e
set -u
set -x

STATUS=1

if /bin/systemctl start certhub-lego-run@lego-test-alternate-chain.service; then
    STATUS=0
fi
/bin/journalctl -u certhub-lego-run@lego-test-alternate-chain.service

exit ${STATUS}
