ifeq ($(dockerargs),)
    dockerargs := --rm --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN
endif

test:
	# Start containers
	docker run $(dockerargs) -d --name certhub-integration-controller certhub-integration-controller /sbin/init
	docker exec certhub-integration-controller bash -c 'ssh-keyscan certhub-integration-node > /etc/ssh/ssh_known_hosts'
	# Run the test
	docker exec certhub-integration-controller su -s /bin/sh -c /home/certhub/input/certbot-cert-csr-import.sh - certhub
	docker exec certhub-integration-controller systemctl start certhub-certbot-run@certbot-cert.service
	docker exec certhub-integration-controller journalctl -u certhub-certbot-run@certbot-cert.service
	# Stop containers
	docker exec certhub-integration-controller systemctl poweroff

certhub-integration-base/certhub-dist.tar.gz:
	cp ../dist/certhub-dist.tar.gz certhub-integration-base/certhub-dist.tar.gz

certhub-integration-base/git-gau-dist.tar.gz:
	curl -L -o certhub-integration-base/git-gau-dist.tar.gz 'https://github.com/znerol/git-gau/releases/download/v1.0.0/git-gau-dist.tar.gz'

certhub-integration-node/certbot-cert.key.pem:
	# Generate private key and csr.
	openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 \
	    -out certhub-integration-node/certbot-cert.key.pem

certhub-integration-controller/certbot-digitalocean.ini:
	# Ensure that DNS credentials are present.
	@test -n "$(LEXICON_DIGITALOCEAN_TOKEN)"
	@echo "dns_digitalocean_token = $(LEXICON_DIGITALOCEAN_TOKEN)" > certhub-integration-controller/certbot-digitalocean.ini

certhub-integration-controller/certbot-cert.csr.pem: certhub-integration-node/certbot-cert.key.pem
	openssl req -new \
	    -config certhub-integration-controller/certbot-cert.csr.cnf \
	    -key certhub-integration-node/certbot-cert.key.pem \
	    -out certhub-integration-controller/certbot-cert.csr.pem

config: \
	certhub-integration-base/certhub-dist.tar.gz \
	certhub-integration-base/git-gau-dist.tar.gz \
	certhub-integration-controller/certbot-cert.csr.pem \
	certhub-integration-controller/certbot-digitalocean.ini \
	certhub-integration-node/certbot-cert.key.pem

images:  config
	docker build -t certhub-integration-base certhub-integration-base
	docker build -t certhub-integration-controller certhub-integration-controller
	docker build -t certhub-integration-node certhub-integration-node

.PHONY: \
	images \
	integration-test \
