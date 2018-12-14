#!/bin/sh

set -e
set -u
set -x

WORKDIR=$(mktemp -d)
cleanup() {
    # Show logs from systemd unit
    journalctl -u certhub-cert-export@export-test.service
    # Remove working directory
    rm -rf "${WORKDIR}"
}
trap cleanup EXIT

chmod 0755 "${WORKDIR}"

# Private key for certificates.
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out "${WORKDIR}/key.pem"

# Expect exported certificate absent.
test ! -e /etc/ssl/certhub/export-test.fullchain.pem

# Setup certs.git repository with outdated certificate.
mkdir -p "${WORKDIR}/export-test"
openssl req -new -x509 -out "${WORKDIR}/export-test.fullchain.pem" -subj /CN=localhost -days 90 -key "${WORKDIR}/key.pem"
cat <<EOF | /bin/su -s /bin/sh - certhub
/usr/bin/env \
    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format "{}/export-test.fullchain.pem" x509 \
    cp "${WORKDIR}/export-test.fullchain.pem" {}
EOF
rm -rf "${WORKDIR}/export-test"

# Run certhub-cert-export
systemctl start certhub-cert-export@export-test.service

# Expect exported certificate present
test -f /etc/ssl/certhub/export-test.fullchain.pem

# Print certificate fingerprint
openssl x509 -in /etc/ssl/certhub/export-test.fullchain.pem -fingerprint -sha256 -noout
