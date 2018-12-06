FROM certhub-integration-base

RUN yum install -y epel-release

RUN yum install -y \
    certbot \
    dehydrated \
    python2-dns-lexicon

ARG WITH_TOR=0
RUN [ $WITH_TOR -eq 0 ] || yum -y install tor
RUN [ $WITH_TOR -eq 0 ] || systemctl enable tor

# Note: tor fails to start up if any of the directories specified in its
# services file is missing.
RUN [ $WITH_TOR -eq 0 ] || mkdir /boot

# Add setup scripts and certhub config
COPY --chown=certhub:certhub context/home /home/certhub/

# Add systemd drop-ins
COPY context/system /etc/systemd/system/
