#!/bin/sh

set -e
set -u
set -x

STATUS=1

# Import csr from setup/dehydrated-test into certs.git
cat <<EOF | /bin/su -s /bin/sh - certhub
/usr/bin/env \
    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {} \
    rsync -av "/home/certhub/setup/dehydrated-test" {}
EOF

su -s /bin/sh -c "dehydrated --register --accept-terms --config /home/certhub/config/dehydrated-test.dehydrated" - certhub
if systemctl start certhub-dehydrated-run@dehydrated-test.service; then
    STATUS=0
fi
journalctl -u certhub-dehydrated-run@dehydrated-test.service

exit ${STATUS}
