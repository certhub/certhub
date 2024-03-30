FROM certhub-integration-base

RUN dnf install -y httpd
RUN systemctl enable httpd

RUN mkdir -p /var/lib/certhub/certs && \
    chown certhub:certhub /var/lib/certhub/certs

EXPOSE 22 443
