#!/bin/sh

set -e
set -u
set -x

STATUS=1

# Import csr from setup/certbot-test into certs.git
cat <<EOF | /bin/su -s /bin/sh - certhub
/usr/bin/env \
    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format "{}/certbot-test/csr.pem" req \
    rsync -av "/home/certhub/setup/certbot-test" {}
EOF

if /bin/systemctl start certhub-certbot-run@certbot-test.service; then
    STATUS=0
fi
/bin/journalctl -u certhub-certbot-run@certbot-test.service

exit ${STATUS}
