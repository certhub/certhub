#!/bin/sh

set -e
set -u
set -x

LOGFILE=$(mktemp)
cleanup() {
    rm -f "${LOGFILE}"
}
trap cleanup EXIT

# Optain commit log.
git --git-dir /var/lib/certhub/certs.git log --oneline > "${LOGFILE}"

# Debug output.
cat "${LOGFILE}" >&2

# Expect two commits.
COUNT=$(wc -l < "${LOGFILE}")
test "${COUNT}" -eq 2

# Check last commit message.
head -n1 "${LOGFILE}" | grep -qw "From controller: Hello node!"
