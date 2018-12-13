#!/bin/sh

set -e
set -u
set -x

WORKDIR=$(mktemp -d)
cleanup() {
    # Show logs from systemd unit
    journalctl -u certhub-cert-expiry@expiry-test.service
    # Remove working directory
    rm -rf "${WORKDIR}"
}
trap cleanup EXIT

chmod 0755 "${WORKDIR}"

RSYNC_ARGS="\
    --checksum \
    --delete \
    --devices \
    --links \
    --perms \
    --recursive \
    --specials \
    --verbose \
"

# Private key for certificates.
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out "${WORKDIR}/key.pem"

# Expect status file is absent
test ! -e /home/certhub/status/expiry-test.expiry.status

# Setup certs.git repository with outdated certificate.
mkdir -p "${WORKDIR}/expiry-test"
faketime -f "-1y" openssl req -new -x509 -out "${WORKDIR}/expiry-test/fullchain.pem" -subj /CN=localhost -days 90 -key "${WORKDIR}/key.pem"
cat <<EOF | /bin/su -s /bin/sh - certhub
/usr/bin/env \
    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format "{}/expiry-test/fullchain.pem" x509 \
    rsync ${RSYNC_ARGS} "${WORKDIR}/expiry-test" {}
EOF
rm -rf "${WORKDIR}/expiry-test"

# Run certhub-cert-expiry
systemctl start certhub-cert-expiry@expiry-test.service

# Expect status file is present
test -f /home/certhub/status/expiry-test.expiry.status

# Simulate certificate renewal.
mkdir -p "${WORKDIR}/expiry-test"
openssl req -new -x509 -out "${WORKDIR}/expiry-test/fullchain.pem" -subj /CN=localhost -days 90 -key "${WORKDIR}/key.pem" 
cat <<EOF | /bin/su -s /bin/sh - certhub
/usr/bin/env \
    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format "{}/expiry-test/fullchain.pem" x509 \
    rsync ${RSYNC_ARGS} "${WORKDIR}/expiry-test" {}
EOF
rm -rf "${WORKDIR}/expiry-test"

# Run certhub-cert-expiry
systemctl start certhub-cert-expiry@expiry-test.service

# Expect status file is absent
test ! -e /home/certhub/status/expiry-test.expiry.status
