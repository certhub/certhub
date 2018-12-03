FROM centos:7

ENV container docker

# Install git, openssl and ssh (yes, really. This is an integration test not a
# production container).
RUN yum install -y git openssl openssh-server
RUN systemctl enable sshd

# Install git-gau and certhub
ADD https://github.com/znerol/git-gau/releases/download/v1.0.0/git-gau-dist.tar.gz /root/
RUN tar -C /usr/local -xf /root/git-gau-dist.tar.gz
COPY certhub-dist.tar.gz /root/certhub-dist.tar.gz
RUN tar -C /usr/local -xf /root/certhub-dist.tar.gz

# Setup certhub user and home directory
RUN groupadd certhub && useradd -m -g certhub -s /usr/bin/git-shell certhub

USER certhub
# Setup git and the certs repository.
RUN git config --global user.name "Certhub CI"
RUN git config --global user.email ci@certhub.io
RUN git config --global push.default simple
RUN git --bare init /home/certhub/certs.git
RUN git gau-exec /home/certhub/certs.git git commit --allow-empty -m'Init'
# Setup certhub config and state directories.
RUN mkdir /home/certhub/config /home/certhub/state
# Note, this will result in identical SSH key on all containers derived from
# this image. Obviously never do this in production.
RUN ssh-keygen -b 1024 -t rsa -f /home/certhub/.ssh/id_rsa -q -N "" -C "Bogus key for CI only. Never use in production"
RUN cp /home/certhub/.ssh/id_rsa.pub /home/certhub/.ssh/authorized_keys
USER root
