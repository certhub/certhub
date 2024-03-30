FROM certhub-integration-base

RUN dnf install -y epel-release

RUN dnf install -y \
    certbot \
    libfaketime \
    python-dns-lexicon

RUN dnf install -y --enablerepo=epel-testing dehydrated

ARG WITH_TOR=0
RUN [ $WITH_TOR -eq 0 ] || dnf -y install tor
RUN [ $WITH_TOR -eq 0 ] || systemctl enable tor

# Note: tor fails to start up if any of the directories specified in its
# services file is missing.
RUN [ $WITH_TOR -eq 0 ] || mkdir /boot

# Add home directory structure
COPY --chown=certhub:certhub context/home /var/lib/certhub/

# Add config directory
COPY context/etc /etc/certhub
