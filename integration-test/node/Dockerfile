FROM certhub-integration-base

RUN yum install -y httpd
RUN systemctl enable httpd

RUN mkdir -p /etc/ssl/certhub && chown certhub:certhub /etc/ssl/certhub

EXPOSE 22 443
