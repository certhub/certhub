#!/bin/sh

set -e
set -u
set -x

STATUS=1

# Scan peer fingerprints.
for delay in 1 2 3 4 5; do
    ssh-keyscan node > /etc/ssh/ssh_known_hosts && break
    sleep $delay
done

cat <<EOF | /bin/su -s /bin/sh - certhub
/usr/bin/env \
    git gau-exec /var/lib/certhub/certs.git \
    git commit --allow-empty --message="From controller: Hello node!"
EOF

if systemctl start "certhub-repo-push@node:-var-lib-certhub-certs.git.service"; then
    STATUS=0
fi
journalctl -u "certhub-repo-push@node:-var-lib-certhub-certs.git.service"

exit ${STATUS}
