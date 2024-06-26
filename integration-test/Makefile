ifeq ($(dockerargs),)
    dockerargs := --rm --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN --stop-signal SIGRTMIN+3
endif

ifeq ($(hostsfx),)
    hostsfx := $(shell openssl rand -hex 4)
endif
export hostsfx

ifeq ($(testenv),)
    ifeq ($(CI),)
        testenv := local
    else
        testenv := github
    endif
endif

# ifeq ($(with_tor),)
#     ifeq ($(CI),)
#         with_tor := 0
#     else
#         with_tor := 1
#     endif
# endif
with_tor := 0

ifneq ($(with_tor),0)
    export DEHYDRATED_CURL_OPTS=-x socks5h://127.0.0.1:9050/ --retry 3 --connect-timeout 180
    export DEHYDRATED_IP_VERSION=4
endif

all: \
	test-cert-expiry \
	test-cert-export \
	test-cert-reload \
	test-cert-send\
	test-repo-push \
	test-certbot \
	test-lego \
	test-lego-alternate-chain

images: \
	base \
	controller \
	node

test-cert-expiry: controller
	# Start containers
	$(eval $@_CONTAINER := $(shell podman run $(dockerargs) -d certhub-integration-controller /sbin/init))
	# Run the test
	podman exec -i $($@_CONTAINER) /bin/sh < test/cert-expiry-test.sh
	# Stop containers
	podman stop $($@_CONTAINER)

test-cert-export: node
	# Start containers
	$(eval $@_CONTAINER := $(shell podman run $(dockerargs) -d certhub-integration-node /sbin/init))
	# Run the test
	podman exec -i $($@_CONTAINER) /bin/sh < test/cert-export-test.sh
	# Stop containers
	podman stop $($@_CONTAINER)

test-cert-reload: node
	# Start containers
	$(eval $@_CONTAINER := $(shell podman run $(dockerargs) -d certhub-integration-node /sbin/init))
	# Run the test
	podman exec -i $($@_CONTAINER) /bin/sh < test/cert-reload-test.sh
	# Stop containers
	podman stop $($@_CONTAINER)

test-cert-send: node
	# Start containers
	$(eval $@_CONTAINER := $(shell podman run $(dockerargs) -d certhub-integration-node /sbin/init))
	# Run the test
	podman exec -i $($@_CONTAINER) /bin/sh < test/cert-send-test.sh
	# Stop containers
	podman stop $($@_CONTAINER)

test-repo-push: controller node
	# Create network
	$(eval $@_IGNORED := $(shell podman network create test-repo-push-$(hostsfx)))
	# Start containers
	$(eval $@_NODE := $(shell podman run $(dockerargs) --net test-repo-push-$(hostsfx) --name node -d certhub-integration-node /sbin/init))
	$(eval $@_CONTROLLER := $(shell podman run $(dockerargs) --net test-repo-push-$(hostsfx) -d certhub-integration-controller /sbin/init))
	# Run the test
	podman exec -i $($@_CONTROLLER) /bin/sh < test/repo-push-test.sh
	podman exec -i $($@_NODE) /bin/sh < test/repo-push-verify.sh
	# Stop containers
	podman stop $($@_CONTROLLER)
	podman stop $($@_NODE)
	podman network rm test-repo-push-$(hostsfx)

test-certbot: controller
	# Start containers
	$(eval $@_CONTAINER := $(shell podman run $(dockerargs) -d certhub-integration-controller /sbin/init))
	# Run the test
	podman exec -i $($@_CONTAINER) /bin/sh < test/test-certbot.sh
	# Stop containers
	podman stop $($@_CONTAINER)

test-lego: controller
	# Start containers
	$(eval $@_CONTAINER := $(shell podman run $(dockerargs) -d certhub-integration-controller /sbin/init))
	# Run the test
	podman exec -i $($@_CONTAINER) /bin/sh < test/test-lego.sh
	# Stop containers
	podman stop $($@_CONTAINER)

test-lego-alternate-chain: controller
	# Start containers
	$(eval $@_CONTAINER := $(shell podman run $(dockerargs) -d certhub-integration-controller /sbin/init))
	# Run the test
	podman exec -i $($@_CONTAINER) /bin/sh < test/test-lego-alternate-chain.sh
	# Stop containers
	podman stop $($@_CONTAINER)

test-dehydrated: controller
	# Start container
	$(eval $@_CONTAINER := $(shell podman run $(dockerargs) -d certhub-integration-controller /sbin/init))
	# Run the test
	podman exec -i $($@_CONTAINER) /bin/sh < test/test-dehydrated.sh
	# Stop containers
	podman stop $($@_CONTAINER)

base/context:
	mkdir base/context
	mkdir -m 0700 base/context/.ssh
	cp ../dist/certhub-dist.tar.gz base/context/certhub-dist.tar.gz
	curl -f -L -o base/context/git-gau-dist.tar.gz 'https://github.com/znerol/git-gau/releases/download/v1.1.0/git-gau-dist.tar.gz'
	curl -f -L -o base/context/lego_v4.16.1_linux_amd64.tar.gz 'https://github.com/go-acme/lego/releases/download/v4.16.1/lego_v4.16.1_linux_amd64.tar.gz'
	ssh-keygen -t ed25519 -f base/context/.ssh/id_ed25519 -q -N "" -C "Bogus key for CI only. Never use in production"
	cp base/context/.ssh/id_ed25519.pub base/context/.ssh/authorized_keys

base: base/context
	podman build -t certhub-integration-base base

node/context:
	mkdir node/context
	# Generate private key and csr.
	openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 \
	    -out node/context/key.pem

node: base node/context
	podman build -t certhub-integration-node node

controller/context: node/context
	# home
	mkdir -p controller/context
	cp -r src/$(testenv)/home controller/context/home
	# etc/certhub
	cp -r src/$(testenv)/etc controller/context/etc
	envsubst < controller/context/etc/certbot-test.certbot.ini.in > controller/context/etc/certbot-test.certbot.ini
	envsubst < controller/context/etc/dehydrated-test.dehydrated.conf.in > controller/context/etc/dehydrated-test.dehydrated.conf
	envsubst < controller/context/etc/certbot-test.csr.cnf.in > controller/context/etc/certbot-test.csr.cnf
	envsubst < controller/context/etc/certhub-certbot-run.env.in > controller/context/etc/certhub-certbot-run.env
	envsubst < controller/context/etc/certhub-dehydrated-run.env.in > controller/context/etc/certhub-dehydrated-run.env
	envsubst < controller/context/etc/lego-test.certhub-lego-run.env.in > controller/context/etc/lego-test.certhub-lego-run.env
	envsubst < controller/context/etc/lego-test-alternate-chain.certhub-lego-run.env.in > controller/context/etc/lego-test-alternate-chain.certhub-lego-run.env
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
	envsubst < controller/context/etc/lego-test-alternate-chain.csr.cnf.in > controller/context/etc/lego-test-alternate-chain.csr.cnf
	openssl req -new \
	    -config controller/context/etc/lego-test-alternate-chain.csr.cnf \
	    -key node/context/key.pem \
	    -out controller/context/etc/lego-test-alternate-chain.csr.pem

controller: base controller/context
	podman build -t certhub-integration-controller --build-arg=WITH_TOR=$(with_tor) controller

.PHONY: \
	all \
	base \
	controller \
	node \
	test-cert-expiry \
	test-cert-export \
	test-cert-reload \
	test-cert-send\
	test-repo-push \
	test-certbot \
	test-dehydrated \
	test-lego \
	test-lego-alternate-chain
