ifeq ($(dockerargs),)
    dockerargs := --rm --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN
endif

ifeq ($(hostsfx),)
    hostsfx := $(shell openssl rand -hex 4)
endif
export hostsfx

ifeq ($(with_tor),)
    ifeq ($(TRAVIS),)
        with_tor := 0
    else
        with_tor := 1
    endif
endif

ifneq ($(with_tor),0)
    dehydrated_proxy_args = -e ALL_PROXY='socks5h://127.0.0.1:9050/'
    dehydrated_proxy_systemd_env = Environment="ALL_PROXY=socks5h://127.0.0.1:9050/"
endif

all: \
    test-certbot \
    test-dehydrated

test-certbot: controller
	# Start containers
	$(eval $@_CONTAINER := $(shell docker run $(dockerargs) -d certhub-integration-controller /sbin/init))
	# Run the test
	docker exec $($@_CONTAINER) su -s /bin/sh -c "/home/certhub/setup/csr-import.sh  /home/certhub/setup/certbot-test" - certhub
	docker exec $($@_CONTAINER) systemctl start certhub-certbot-run@certbot-test.service
	docker exec $($@_CONTAINER) journalctl -u certhub-certbot-run@certbot-test.service
	# Stop containers
	docker exec $($@_CONTAINER) systemctl poweroff
	docker wait $($@_CONTAINER)

test-dehydrated: controller
	# Start container
	$(eval $@_CONTAINER := $(shell docker run $(dockerargs) $(dehydrated_proxy_args) -d certhub-integration-controller /sbin/init))
	# Run the test
	docker exec $($@_CONTAINER) su -s /bin/sh -c "/home/certhub/setup/csr-import.sh /home/certhub/setup/dehydrated-test" - certhub
	docker exec $($@_CONTAINER) su -s /bin/sh -c "dehydrated --register --accept-terms --config /home/certhub/config/dehydrated-test.dehydrated" - certhub
	docker exec $($@_CONTAINER) systemctl start certhub-dehydrated-run@dehydrated-test.service
	docker exec $($@_CONTAINER) journalctl -u certhub-dehydrated-run@dehydrated-test.service
	# Stop containers
	docker exec $($@_CONTAINER) systemctl poweroff
	docker wait $($@_CONTAINER)

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
	    -out node/context/key.pem

node: base node/context
	docker build -t certhub-integration-node node

controller/context-credentials:
	mkdir -p controller/context/home
	mkdir -p controller/context/system/certhub-dehydrated-run@.service.d
	# Ensure that LEXICON_DIGITALOCEAN_TOKEN environment variable is set.
	@test -n "$(LEXICON_DIGITALOCEAN_TOKEN)"
	# Credentials for dehydrated / lexicon
	@echo "[Service]" > controller/context/system/certhub-dehydrated-run@.service.d/dns-account.conf
	@echo "Environment=DELEGATED=ci.certhub.io" >> controller/context/system/certhub-dehydrated-run@.service.d/dns-account.conf
	@echo "Environment=PROVIDER=digitalocean" >> controller/context/system/certhub-dehydrated-run@.service.d/dns-account.conf
	@echo "Environment=LEXICON_DIGITALOCEAN_TOKEN=$(LEXICON_DIGITALOCEAN_TOKEN)" >> controller/context/system/certhub-dehydrated-run@.service.d/dns-account.conf
	@echo "$(dehydrated_proxy_systemd_env)" >> controller/context/system/certhub-dehydrated-run@.service.d/dns-account.conf
	# Credentials for certbot
	@echo "dns_digitalocean_token = $(LEXICON_DIGITALOCEAN_TOKEN)" > controller/context/home/certbot-digitalocean.ini

controller/context: controller/context-credentials node/context
	mkdir -p controller/context/home/certbot/config
	mkdir -p controller/context/home/certbot/log
	mkdir -p controller/context/home/certbot/work
	mkdir -p controller/context/home/dehydrated
	mkdir -p controller/context/home/.config/letsencrypt
	cp src/certbot-cli.ini controller/context/home/.config/letsencrypt/cli.ini
	cp -r src/config controller/context/home/config
	cp -r src/scripts controller/context/home/scripts
	cp -r src/setup controller/context/home/setup
	envsubst < controller/context/home/setup/certbot-test/csr.cnf.in > controller/context/home/setup/certbot-test/csr.cnf
	openssl req -new \
	    -config controller/context/home/setup/certbot-test/csr.cnf \
	    -key node/context/key.pem \
	    -out controller/context/home/setup/certbot-test/csr.pem
	envsubst < controller/context/home/setup/dehydrated-test/csr.cnf.in > controller/context/home/setup/dehydrated-test/csr.cnf
	openssl req -new \
	    -config controller/context/home/setup/dehydrated-test/csr.cnf \
	    -key node/context/key.pem \
	    -out controller/context/home/setup/dehydrated-test/csr.pem

controller: base controller/context
	docker build -t certhub-integration-controller --build-arg=WITH_TOR=$(with_tor) controller


.PHONY: \
	all \
	base \
	controller \
	controller/context-credentials \
	node \
	test-certbot \
	test-dehydrated \
