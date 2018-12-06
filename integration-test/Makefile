ifeq ($(dockerargs),)
    dockerargs := --rm --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN --stop-signal SIGRTMIN+3
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
	docker exec -i $($@_CONTAINER) /bin/sh < test/test-certbot.sh
	# Stop containers
	docker stop $($@_CONTAINER)

test-dehydrated: controller
	# Start container
	$(eval $@_CONTAINER := $(shell docker run $(dockerargs) $(dehydrated_proxy_args) -d certhub-integration-controller /sbin/init))
	# Run the test
	docker exec -i $($@_CONTAINER) /bin/sh < test/test-dehydrated.sh
	# Stop containers
	docker stop $($@_CONTAINER)

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

controller/context: node/context
	mkdir -p controller/context/system/certhub-dehydrated-run@.service.d
	echo '[Service]' > controller/context/system/certhub-dehydrated-run@.service.d/tor.conf
	echo "$(dehydrated_proxy_systemd_env)" >> controller/context/system/certhub-dehydrated-run@.service.d/tor.conf
	mkdir -p controller/context/home/certbot/config
	mkdir -p controller/context/home/certbot/log
	mkdir -p controller/context/home/certbot/work
	mkdir -p controller/context/home/dehydrated
	mkdir -p controller/context/home/.config/letsencrypt
	cp src/certbot-cli.ini controller/context/home/.config/letsencrypt/cli.ini
	cp -r src/config controller/context/home/config
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
