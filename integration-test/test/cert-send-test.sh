#!/bin/sh

set -e
set -u
set -x

MAILBIN=/usr/local/bin/mail
test ! -e "${MAILBIN}"

WORKDIR=$(mktemp -d)
MAILOUT="${WORKDIR}/mail.out"
cleanup() {
    # Show logs from systemd unit
    journalctl -u certhub-cert-send@send-test-with-multi.service
    # Remove working directory
    rm -rf "${WORKDIR}"
    rm -f "${MAILBIN}"
}
trap cleanup EXIT

chgrp certhub "${WORKDIR}"
chmod 770 "${WORKDIR}"

systemctl daemon-reload

# Generate fake self-signed certificates.
openssl req -x509 -nodes -batch -newkey rsa:1024 -keyout /dev/null -out "/var/lib/certhub/certs/send-test-with-multi.fullchain.pem"

# Generate a fake mail-command.
cat <<EOF > "${MAILBIN}"
#!/bin/sh

echo "Fake mail-command called with args: \${@}" >&2

set -e
set -u

{
    printf "%q " "\${@}"
    echo
    cat
} >> "${MAILOUT}"
EOF
chmod +x "${MAILBIN}"

# Generate expected output from fake-mail.
MAILEXPECT="${WORKDIR}/mail.expect"
{
    printf "%q " "-s" "[Certhub] Issue/renew send-test-with-multi" "root@localhost"
    echo
    cat "/var/lib/certhub/certs/send-test-with-multi.fullchain.pem"
    printf "%q " "-s" "[Certhub] Issue/renew send-test-with-multi" "admin@example.com"
    echo
    cat "/var/lib/certhub/certs/send-test-with-multi.fullchain.pem"
} > "${MAILEXPECT}"

# Configuration file.
cat <<EOF > /etc/certhub/send-test-with-multi.destinations-send.txt
root@localhost
admin@example.com
EOF

# Expect send output for send-test-with-multi absent
test ! -e "${MAILOUT}"

# Run certhub-cert-send
systemctl start certhub-cert-send@send-test-with-multi.service

# Expect send output for send-test-with-multi present
diff -s "${MAILOUT}" "${MAILEXPECT}"
