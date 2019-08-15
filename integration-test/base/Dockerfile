FROM centos:7

ENV container docker

# Install git, openssl and ssh (yes, really. This is an integration test not a
# production container).
RUN yum install -y git openssl openssh-server
RUN systemctl enable sshd

# Install git-gau and certhub
COPY context/git-gau-dist.tar.gz context/certhub-dist.tar.gz context/lego_v3.0.2_linux_amd64.tar.gz /root/
RUN \
    tar -C /usr/local -xf /root/git-gau-dist.tar.gz && \
    tar -C /usr/local -xf /root/certhub-dist.tar.gz && \
    tar -C /usr/local/bin -xf /root/lego_v3.0.2_linux_amd64.tar.gz lego && \
    chmod +x /usr/local/bin/lego

# Setup configuration directory
RUN mkdir /etc/certhub

# Setup certhub system user and home directory
RUN groupadd -r certhub && \
    useradd -r -g certhub -s /usr/bin/git-shell -d /var/lib/certhub certhub && \
    mkdir /var/lib/certhub && \
    chown certhub:certhub /var/lib/certhub

# Note, this will result in identical SSH key on all containers derived from
# this image. Obviously never do this in production.
COPY --chown=certhub:certhub context/.ssh /var/lib/certhub/.ssh
RUN chmod 0700 /var/lib/certhub/.ssh

USER certhub
# Setup git and the certs repository.
RUN \
    git config --global user.name "Certhub CI" && \
    git config --global user.email ci@certhub.io && \
    git config --global push.default simple && \
    git --bare init /var/lib/certhub/certs.git && \
    git gau-exec /var/lib/certhub/certs.git git commit --allow-empty -m'Init'
# Setup certhub private and status directories.
RUN mkdir -m 0700 /var/lib/certhub/private && \
    mkdir /var/lib/certhub/status
USER root
