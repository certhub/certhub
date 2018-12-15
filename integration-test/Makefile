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
    export DEHYDRATED_CURL_OPTS=-x socks5h://127.0.0.1:9050/ --retry 3 --connect-timeout 180
    export DEHYDRATED_IP_VERSION=4
endif

all: \
	test-cert-expiry \
	test-cert-export \
	test-cert-reload \
	test-repo-push \
	test-certbot \
	test-lego \
	test-dehydrated

images: \
	base \
	controller \
	node

test-cert-expiry: controller
	# Start containers
	$(eval $@_CONTAINER := $(shell docker run $(dockerargs) -d certhub-integration-controller /sbin/init))
	# Run the test
	docker exec -i $($@_CONTAINER) /bin/sh < test/cert-expiry-test.sh
	# Stop containers
	docker stop $($@_CONTAINER)

test-cert-export: node
	# Start containers
	$(eval $@_CONTAINER := $(shell docker run $(dockerargs) -d certhub-integration-node /sbin/init))
	# Run the test
	docker exec -i $($@_CONTAINER) /bin/sh < test/cert-export-test.sh
	# Stop containers
	docker stop $($@_CONTAINER)

test-cert-reload: node
	# Start containers
	$(eval $@_CONTAINER := $(shell docker run $(dockerargs) -d certhub-integration-node /sbin/init))
	# Run the test
	docker exec -i $($@_CONTAINER) /bin/sh < test/cert-reload-test.sh
	# Stop containers
	docker stop $($@_CONTAINER)

test-repo-push: controller node
	# Start containers
	$(eval $@_NODE := $(shell docker run $(dockerargs) -d certhub-integration-node /sbin/init))
	$(eval $@_CONTROLLER := $(shell docker run $(dockerargs) --link=$($@_NODE):node -d certhub-integration-controller /sbin/init))
	# Run the test
	docker exec -i $($@_CONTROLLER) /bin/sh < test/repo-push-test.sh
	docker exec -i $($@_NODE) /bin/sh < test/repo-push-verify.sh
	# Stop containers
	docker stop $($@_CONTROLLER)
	docker stop $($@_NODE)

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
	# etc/certhub
	cp -r src/$(testenv)/etc controller/context/etc
	envsubst < controller/context/etc/certbot-test.certbot.ini.in > controller/context/etc/certbot-test.certbot.ini
	envsubst < controller/context/etc/dehydrated-test.dehydrated.conf.in > controller/context/etc/dehydrated-test.dehydrated.conf
	envsubst < controller/context/etc/lego-test.lego.args.in > controller/context/etc/lego-test.lego.args
	envsubst < controller/context/etc/certbot-test.csr.cnf.in > controller/context/etc/certbot-test.csr.cnf
	openssl req -new \
	    -config controller/context/etc/certbot-test.csr.cnf \
	    -key node/context/key.pem \
	    -out controller/context/etc/certbot-test.csr.pem
	envsubst < controller/context/etc/dehydrated-test.csr.cnf.in > controller/context/etc/dehydrated-test.csr.cnf
	openssl req -new \
	    -config controller/context/etc/dehydrated-test.csr.cnf \
	    -key node/context/key.pem \
	    -out controller/context/etc/dehydrated-test.csr.pem
	envsubst < controller/context/etc/lego-test.csr.cnf.in > controller/context/etc/lego-test.csr.cnf
	openssl req -new \
	    -config controller/context/etc/lego-test.csr.cnf \
	    -key node/context/key.pem \
	    -out controller/context/etc/lego-test.csr.pem
	# etc/system/systemd
	cp -r src/$(testenv)/system controller/context/system
	envsubst < controller/context/system/certhub-certbot-run@.service.d/hook-lexicon-auth.conf.in > controller/context/system/certhub-certbot-run@.service.d/hook-lexicon-auth.conf
	envsubst < controller/context/system/certhub-dehydrated-run@.service.d/hook-lexicon-auth.conf.in > controller/context/system/certhub-dehydrated-run@.service.d/hook-lexicon-auth.conf
	envsubst < controller/context/system/certhub-lego-run@.service.d/lego-challenge.conf.in > controller/context/system/certhub-lego-run@.service.d/lego-challenge.conf

controller: base controller/context
	docker build -t certhub-integration-controller --build-arg=WITH_TOR=$(with_tor) controller

.PHONY: \
	all \
	base \
	controller \
	node \
	test-cert-expiry \
	test-cert-export \
	test-cert-reload \
	test-repo-push \
	test-certbot \
	test-dehydrated \
	test-lego
