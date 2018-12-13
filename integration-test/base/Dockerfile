FROM centos:7

ENV container docker

# Install git, openssl and ssh (yes, really. This is an integration test not a
# production container).
RUN yum install -y git openssl openssh-server
RUN systemctl enable sshd

# Install git-gau and certhub
COPY context/git-gau-dist.tar.gz context/certhub-dist.tar.gz context/lego_v1.2.1_linux_amd64.tar.gz /root/
RUN \
    tar -C /usr/local -xf /root/git-gau-dist.tar.gz && \
    tar -C /usr/local -xf /root/certhub-dist.tar.gz && \
    tar -C /usr/local/bin -xf /root/lego_v1.2.1_linux_amd64.tar.gz lego && \
    chmod +x /usr/local/bin/lego

# Setup certhub user and home directory
RUN groupadd certhub && useradd -m -g certhub -s /usr/bin/git-shell certhub

# Note, this will result in identical SSH key on all containers derived from
# this image. Obviously never do this in production.
COPY --chown=certhub:certhub context/.ssh /home/certhub/.ssh
RUN chmod 0700 /home/certhub/.ssh

USER certhub
# Setup git and the certs repository.
RUN \
    git config --global user.name "Certhub CI" && \
    git config --global user.email ci@certhub.io && \
    git config --global push.default simple && \
    git --bare init /home/certhub/certs.git && \
    git gau-exec /home/certhub/certs.git git commit --allow-empty -m'Init'
# Setup certhub config and status directories.
RUN mkdir /home/certhub/config /home/certhub/status
USER root
