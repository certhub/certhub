#!/bin/sh

set -e
set -u
set -x

STATUS=1

# Import csr from setup/lego-test into certs.git
cat <<EOF | /bin/su -s /bin/sh - certhub
/usr/bin/env \
    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {} \
    rsync -av "/home/certhub/setup/lego-test" {}
EOF

if /bin/systemctl start certhub-lego-run@lego-test.service; then
    STATUS=0
fi
/bin/journalctl -u certhub-lego-run@lego-test.service

exit ${STATUS}
