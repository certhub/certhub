ifeq ($(dockerargs),)
    dockerargs := --rm --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN
endif

all: \
    test-certbot \
    test-dehydrated

test-certbot: controller
	# Start containers
	docker run $(dockerargs) -d --name certhub-integration-controller certhub-integration-controller /sbin/init
	# Run the test
	docker exec certhub-integration-controller su -s /bin/sh -c /home/certhub/setup/certbot-cert-csr-import.sh - certhub
	docker exec certhub-integration-controller systemctl start certhub-certbot-run@certbot-cert.service
	docker exec certhub-integration-controller journalctl -u certhub-certbot-run@certbot-cert.service
	# Stop containers
	docker exec certhub-integration-controller systemctl poweroff
	docker wait certhub-integration-controller

test-dehydrated: controller
	# Start containers
	docker run $(dockerargs) -d --name certhub-integration-controller certhub-integration-controller /sbin/init
	# Run the test
	docker exec certhub-integration-controller su -s /bin/sh -c /home/certhub/setup/certbot-cert-csr-import.sh - certhub
	docker exec certhub-integration-controller su -s /bin/sh -c "dehydrated --register --accept-terms --config /home/certhub/config/certbot-cert.dehydrated" - certhub
	docker exec certhub-integration-controller systemctl start certhub-dehydrated-run@certbot-cert.service
	docker exec certhub-integration-controller journalctl -u certhub-dehydrated-run@certbot-cert.service
	# Stop containers
	docker exec certhub-integration-controller systemctl poweroff
	docker wait certhub-integration-controller

base/context:
	mkdir base/context
	mkdir -m 0700 base/context/.ssh
	cp ../dist/certhub-dist.tar.gz base/context/certhub-dist.tar.gz
	curl -L -o base/context/git-gau-dist.tar.gz 'https://github.com/znerol/git-gau/releases/download/v1.0.0/git-gau-dist.tar.gz'
	ssh-keygen -b 1024 -t rsa -f base/context/.ssh/id_rsa -q -N "" -C "Bogus key for CI only. Never use in production"
	cp base/context/.ssh/id_rsa.pub base/context/.ssh/authorized_keys

base: base/context
	docker build -t certhub-integration-base base

node/context:
	mkdir node/context
	# Generate private key and csr.
	openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 \
	    -out node/context/certbot-cert.key.pem

node: base node/context
	docker build -t certhub-integration-node node

controller/context: node/context
	mkdir -p controller/context/home
	mkdir -p controller/context/system/certhub-dehydrated-run@.service.d
	# Ensure that LEXICON_DIGITALOCEAN_TOKEN environment variable is set.
	@test -n "$(LEXICON_DIGITALOCEAN_TOKEN)"
	# Credentials for dehydrated / lexicon
	@echo "[Service]" > controller/context/system/certhub-dehydrated-run@.service.d/dns-account.conf
	@echo "Environment=PROVIDER=digitalocean" >> controller/context/system/certhub-dehydrated-run@.service.d/dns-account.conf
	@echo "Environment=LEXICON_DIGITALOCEAN_TOKEN=$(LEXICON_DIGITALOCEAN_TOKEN)" >> controller/context/system/certhub-dehydrated-run@.service.d/dns-account.conf
	# Credentials for certbot
	@echo "dns_digitalocean_token = $(LEXICON_DIGITALOCEAN_TOKEN)" > controller/context/home/certbot-digitalocean.ini
	mkdir -p controller/context/home/certbot/config
	mkdir -p controller/context/home/certbot/log
	mkdir -p controller/context/home/certbot/work
	mkdir -p controller/context/home/dehydrated
	mkdir -p controller/context/home/.config/letsencrypt
	cp src/certbot-cli.ini controller/context/home/.config/letsencrypt/cli.ini
	cp -r src/config controller/context/home/config
	cp -r src/scripts controller/context/home/scripts
	cp -r src/setup controller/context/home/setup
	openssl req -new \
	    -config controller/context/home/setup/certbot-cert/csr.cnf \
	    -key node/context/certbot-cert.key.pem \
	    -out controller/context/home/setup/certbot-cert/csr.pem

controller: base controller/context
	docker build -t certhub-integration-controller controller


.PHONY: \
	all \
	base \
	controller \
	images \
	node \
	test-certbot \
	test-dehydrated \
