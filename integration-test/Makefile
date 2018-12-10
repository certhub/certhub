ifeq ($(dockerargs),)
    dockerargs := --rm --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN --stop-signal SIGRTMIN+3
endif

ifeq ($(hostsfx),)
    hostsfx := $(shell openssl rand -hex 4)
endif
export hostsfx

ifeq ($(testenv),)
    ifeq ($(TRAVIS),)
        testenv := local
    else
        testenv := travis
    endif
endif

ifeq ($(with_tor),)
    ifeq ($(TRAVIS),)
        with_tor := 0
    else
        with_tor := 1
    endif
endif

ifneq ($(with_tor),0)
    export DEHYDRATED_CURL_OPTS=-x socks5h://127.0.0.1:9050/
    export DEHYDRATED_IP_VERSION=4
endif

all: \
    test-certbot \
    test-lego \
    test-dehydrated

test-certbot: controller
	# Start containers
	$(eval $@_CONTAINER := $(shell docker run $(dockerargs) -d certhub-integration-controller /sbin/init))
	# Run the test
	docker exec -i $($@_CONTAINER) /bin/sh < test/test-certbot.sh
	# Stop containers
	docker stop $($@_CONTAINER)

test-lego: controller
	# Start containers
	$(eval $@_CONTAINER := $(shell docker run $(dockerargs) -d certhub-integration-controller /sbin/init))
	# Run the test
	docker exec -i $($@_CONTAINER) /bin/sh < test/test-lego.sh
	# Stop containers
	docker stop $($@_CONTAINER)

test-dehydrated: controller
	# Start container
	$(eval $@_CONTAINER := $(shell docker run $(dockerargs) -d certhub-integration-controller /sbin/init))
	# Run the test
	docker exec -i $($@_CONTAINER) /bin/sh < test/test-dehydrated.sh
	# Stop containers
	docker stop $($@_CONTAINER)

base/context:
	mkdir base/context
	mkdir -m 0700 base/context/.ssh
	cp ../dist/certhub-dist.tar.gz base/context/certhub-dist.tar.gz
	curl -L -o base/context/git-gau-dist.tar.gz 'https://github.com/znerol/git-gau/releases/download/v1.0.0/git-gau-dist.tar.gz'
	curl -L -o base/context/lego_v1.2.1_linux_amd64.tar.gz 'https://github.com/xenolf/lego/releases/download/v1.2.1/lego_v1.2.1_linux_amd64.tar.gz'
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
	# home
	mkdir -p controller/context
	cp -r src/$(testenv)/home controller/context/home
	# config
	envsubst < controller/context/home/config/certbot-test.certbot.ini.in > controller/context/home/config/certbot-test.certbot.ini
	envsubst < controller/context/home/config/dehydrated-test.dehydrated.in > controller/context/home/config/dehydrated-test.dehydrated
	envsubst < controller/context/home/config/lego-test.lego.in > controller/context/home/config/lego-test.lego
	# setup
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
	envsubst < controller/context/home/setup/lego-test/csr.cnf.in > controller/context/home/setup/lego-test/csr.cnf
	openssl req -new \
	    -config controller/context/home/setup/lego-test/csr.cnf \
	    -key node/context/key.pem \
	    -out controller/context/home/setup/lego-test/csr.pem
	# system
	cp -r src/$(testenv)/system controller/context/system
	envsubst < controller/context/system/certhub-certbot-run@.service.d/challenge.conf.in > controller/context/system/certhub-certbot-run@.service.d/challenge.conf
	envsubst < controller/context/system/certhub-dehydrated-run@.service.d/challenge.conf.in > controller/context/system/certhub-dehydrated-run@.service.d/challenge.conf
	envsubst < controller/context/system/certhub-lego-run@.service.d/challenge.conf.in > controller/context/system/certhub-lego-run@.service.d/challenge.conf

controller: base controller/context
	docker build -t certhub-integration-controller --build-arg=WITH_TOR=$(with_tor) controller

.PHONY: \
	all \
	base \
	controller \
	node \
	test-certbot \
	test-dehydrated \
	test-lego \
