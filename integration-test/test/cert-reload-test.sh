#!/bin/sh

set -e
set -u
set -x

WORKDIR=$(mktemp -d)
cleanup() {
    # Show logs from systemd unit
    journalctl -u test-tls-service@instance1.service
    journalctl -u test-tls-service@instance2.service
    journalctl -u test-fail-service@instance3.service
    journalctl -u test-tls-service@instance4.service
    journalctl -u certhub-cert-reload@reload-test.service
    # Remove working directory
    rm -rf "${WORKDIR}"
}
trap cleanup EXIT

cat <<EOF > /etc/systemd/system/test-tls-service@.service
[Service]
RemainAfterExit=yes
ExecStart=/usr/bin/echo started %i
ExecReload=/usr/bin/touch "${WORKDIR}/%i.reloaded"
EOF

cat <<EOF > /etc/systemd/system/test-fail-service@.service
[Service]
RemainAfterExit=yes
ExecStart=/usr/bin/echo started %i
ExecReload=/bin/false
EOF

systemctl daemon-reload

systemctl start test-tls-service@instance1.service
systemctl start test-tls-service@instance2.service
systemctl start test-fail-service@instance3.service
systemctl start test-tls-service@instance4.service

cat <<EOF > /home/certhub/config/reload-test-with-multi.services-reload.txt
test-tls-service@instance1.service
test-tls-service@instance2.service
EOF

cat <<EOF > /home/certhub/config/reload-test-with-fails.services-reload.txt
test-tls-service@instance3.service
test-tls-service@instance4.service
EOF

# Expect reload markers for reload-test-with-multi absent
test ! -e "${WORKDIR}/instance1.reloaded"
test ! -e "${WORKDIR}/instance2.reloaded"

# Run certhub-cert-reload
systemctl start certhub-cert-reload@reload-test-with-multi.service

# Expect reload markers for reload-test-with-multi present
test -f "${WORKDIR}/instance1.reloaded"
test -f "${WORKDIR}/instance2.reloaded"

# Expect reload markers for reload-test-with-fails absent
test ! -e "${WORKDIR}/instance3.reloaded"
test ! -e "${WORKDIR}/instance4.reloaded"

# Run certhub-cert-reload and expect it to fail
! systemctl start certhub-cert-reload@reload-test-with-fails.service

# Expect failed reload marker for reload-test-with-fails absent
test ! -e "${WORKDIR}/instance3.reloaded"

# Expect working reload marker for reload-test-with-fails present
test -f "${WORKDIR}/instance4.reloaded"
