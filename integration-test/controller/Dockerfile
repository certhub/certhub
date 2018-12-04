FROM certhub-integration-base

RUN yum install -y epel-release

RUN yum install -y \
    certbot \
    dehydrated \
    python2-certbot-dns-digitalocean \
    python2-dns-lexicon

# Add setup scripts and certhub config
COPY --chown=certhub:certhub context/home /home/certhub/
