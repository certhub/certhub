FROM certhub-integration-base

RUN yum install -y epel-release

RUN yum install -y \
    certbot \
    libfaketime \
    python3-dns-lexicon

RUN yum install -y --enablerepo=epel-testing dehydrated

ARG WITH_TOR=0
RUN [ $WITH_TOR -eq 0 ] || yum -y install tor
RUN [ $WITH_TOR -eq 0 ] || systemctl enable tor

# Add home directory structure
COPY --chown=certhub:certhub context/home /var/lib/certhub/

# Add config directory
COPY context/etc /etc/certhub
