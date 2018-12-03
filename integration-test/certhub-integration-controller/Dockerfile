FROM certhub-integration-base

RUN yum install -y epel-release

RUN yum install -y \
    certbot \
    dehydrated \
    python2-certbot-dns-digitalocean \
    python2-dns-lexicon

# Add CSR import script.
RUN mkdir -p /home/certhub/input/
COPY certbot-cert-csr-import.sh /home/certhub/input/certbot-cert-csr-import.sh
RUN chmod +x /home/certhub/input/certbot-cert-csr-import.sh

# Add CSR.
RUN mkdir -p /home/certhub/input/certbot-cert/
COPY certbot-cert.csr.pem /home/certhub/input/certbot-cert/csr.pem
COPY certbot-cert.csr.cnf /home/certhub/input/certbot-cert/csr.cnf

# Add certhub config and digitalocean credentials.
COPY certbot-cert.certbot.ini /home/certhub/config/certbot-cert.certbot.ini
COPY certbot-digitalocean.ini /home/certhub/certbot-digitalocean.ini

# Add certbot user-config
RUN mkdir -p \
    /home/certhub/.config/letsencrypt \
    /home/certhub/certbot/config \
    /home/certhub/certbot/log \
    /home/certhub/certbot/work
RUN chown -R certhub.certhub /home/certhub/certbot
COPY certbot-cli.ini /home/certhub/.config/letsencrypt/cli.ini
