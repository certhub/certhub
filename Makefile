ifeq ($(prefix),)
    prefix := /usr/local
endif
ifeq ($(exec_prefix),)
    exec_prefix := $(prefix)
endif
ifeq ($(bindir),)
    bindir := $(exec_prefix)/bin
endif
ifeq ($(libdir),)
    libdir := $(exec_prefix)/lib
endif
ifeq ($(systemddir),)
    systemddir := $(libdir)/systemd
endif
ifeq ($(systemdsystemdir),)
    systemdsystemdir := $(systemddir)/system
endif
ifeq ($(datarootdir),)
    datarootdir := $(prefix)/share
endif
ifeq ($(mandir),)
    mandir := $(datarootdir)/man
endif
ifeq ($(python),)
    python := python
endif

all: bin test doc

%.1 : %.1.md
	pandoc -s -t man $< -o $@

bin:
	# empty for now

lint: bin
	shellcheck bin/certhub-certbot-run
	shellcheck bin/certhub-dehydrated-run
	shellcheck bin/certhub-lego-run
	shellcheck bin/certhub-message-format
	shellcheck lib/certbot-hooks/lexicon-auth
	shellcheck lib/certbot-hooks/nsupdate-auth
	shellcheck lib/dehydrated-hooks/lexicon-auth
	shellcheck lib/dehydrated-hooks/nsupdate-auth

test: bin
	PATH="$(shell pwd)/bin:${PATH}" $(python) -m test

doc: \
	doc/certhub-certbot-run.1 \
	doc/certhub-dehydrated-run.1 \
	doc/certhub-lego-run.1 \
	doc/certhub-message-format.1

clean:
	-rm -f doc/certhub-certbot-run.1
	-rm -f doc/certhub-dehydrated-run.1
	-rm -f doc/certhub-lego-run.1
	-rm -f doc/certhub-message-format.1
	-rm -rf dist
	-rm -rf build

install-doc: doc
	install -m 0644 -D doc/certhub-certbot-run.1 $(DESTDIR)$(mandir)/man1/certhub-certbot-run.1
	install -m 0644 -D doc/certhub-dehydrated-run.1 $(DESTDIR)$(mandir)/man1/certhub-dehydrated-run.1
	install -m 0644 -D doc/certhub-lego-run.1 $(DESTDIR)$(mandir)/man1/certhub-lego-run.1
	install -m 0644 -D doc/certhub-message-format.1 $(DESTDIR)$(mandir)/man1/certhub-message-format.1

install-bin: bin
	install -m 0755 -D bin/certhub-certbot-run $(DESTDIR)$(bindir)/certhub-certbot-run
	install -m 0755 -D bin/certhub-dehydrated-run $(DESTDIR)$(bindir)/certhub-dehydrated-run
	install -m 0755 -D bin/certhub-lego-run $(DESTDIR)$(bindir)/certhub-lego-run
	install -m 0755 -D bin/certhub-message-format $(DESTDIR)$(bindir)/certhub-message-format
	install -m 0755 -D lib/certbot-hooks/lexicon-auth $(DESTDIR)$(libdir)/certhub/certbot-hooks/lexicon-auth
	ln -s -f lexicon-auth $(DESTDIR)$(libdir)/certhub/certbot-hooks/lexicon-cleanup
	install -m 0755 -D lib/certbot-hooks/nsupdate-auth $(DESTDIR)$(libdir)/certhub/certbot-hooks/nsupdate-auth
	ln -s -f nsupdate-auth $(DESTDIR)$(libdir)/certhub/certbot-hooks/nsupdate-cleanup
	install -m 0755 -D lib/dehydrated-hooks/lexicon-auth $(DESTDIR)$(libdir)/certhub/dehydrated-hooks/lexicon-auth
	install -m 0755 -D lib/dehydrated-hooks/nsupdate-auth $(DESTDIR)$(libdir)/certhub/dehydrated-hooks/nsupdate-auth
	install -m 0644 -D lib/systemd/certhub-cert-export@.path $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.path
	install -m 0644 -D lib/systemd/certhub-cert-export@.service $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.service
	install -m 0644 -D lib/systemd/certhub-cert-reload@.path $(DESTDIR)$(systemdsystemdir)/certhub-cert-reload@.path
	install -m 0644 -D lib/systemd/certhub-cert-reload@.service $(DESTDIR)$(systemdsystemdir)/certhub-cert-reload@.service
	install -m 0644 -D lib/systemd/certhub-certbot-run@.path $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.path
	install -m 0644 -D lib/systemd/certhub-certbot-run@.service $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service
	install -m 0644 -D lib/systemd/certhub-certrot-expiry@.path $(DESTDIR)$(systemdsystemdir)/certhub-certrot-expiry@.path
	install -m 0644 -D lib/systemd/certhub-certrot-expiry@.service $(DESTDIR)$(systemdsystemdir)/certhub-certrot-expiry@.service
	install -m 0644 -D lib/systemd/certhub-certrot-expiry@.timer $(DESTDIR)$(systemdsystemdir)/certhub-certrot-expiry@.timer
	install -m 0644 -D lib/systemd/certhub-certrot-server-https@.service $(DESTDIR)$(systemdsystemdir)/certhub-certrot-server-https@.service
	install -m 0644 -D lib/systemd/certhub-dehydrated-run@.path $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.path
	install -m 0644 -D lib/systemd/certhub-dehydrated-run@.service $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service
	install -m 0644 -D lib/systemd/certhub-lego-run@.path $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.path
	install -m 0644 -D lib/systemd/certhub-lego-run@.service $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service
	install -m 0644 -D lib/systemd/certhub-repo-push@.path $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.path
	install -m 0644 -D lib/systemd/certhub-repo-push@.service $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.service

install: install-bin install-doc

uninstall:
	-rm -f $(DESTDIR)$(bindir)/certhub-certbot-run
	-rm -f $(DESTDIR)$(bindir)/certhub-dehydrated-run
	-rm -f $(DESTDIR)$(bindir)/certhub-lego-run
	-rm -f $(DESTDIR)$(bindir)/certhub-message-format
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-certbot-run.1
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-dehydrated-run.1
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-lego-run.1
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-message-format.1
	-rm -f $(DESTDIR)$(libdir)/certhub/certbot-hooks/lexicon-auth
	-rm -f $(DESTDIR)$(libdir)/certhub/certbot-hooks/lexicon-cleanup
	-rm -f $(DESTDIR)$(libdir)/certhub/certbot-hooks/nsupdate-auth
	-rm -f $(DESTDIR)$(libdir)/certhub/certbot-hooks/nsupdate-cleanup
	-rm -f $(DESTDIR)$(libdir)/certhub/dehydrated-hooks/lexicon-auth
	-rm -f $(DESTDIR)$(libdir)/certhub/dehydrated-hooks/nsupdate-auth
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-reload@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-reload@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certrot-expiry@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certrot-expiry@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certrot-expiry@.timer
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certrot-server-https@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.service

dist-bin:
	-rm -rf build
	make DESTDIR=build prefix=/ install
	mkdir -p dist
	tar --owner=root:0 --group=root:0 -czf dist/certhub-dist.tar.gz -C build .

dist-src:
	mkdir -p dist
	git archive -o dist/certhub-src.tar.gz HEAD

dist: dist-src dist-bin

integration-test:
	# Ensure that DNS credentials are present.
	@test -n "$(LEXICON_DIGITALOCEAN_TOKEN)"
	@echo "dns_digitalocean_token = $(LEXICON_DIGITALOCEAN_TOKEN)" > integration-test/certhub-integration-controller/certbot-digitalocean.ini
	# Generate private key and csr.
	openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 \
	    -out integration-test/certhub-integration-node/certbot-cert.key.pem
	openssl req -new \
	    -config integration-test/certhub-integration-controller/certbot-cert.csr.cnf \
	    -key integration-test/certhub-integration-node/certbot-cert.key.pem \
	    -out integration-test/certhub-integration-controller/certbot-cert.csr.pem
	cp dist/certhub-dist.tar.gz integration-test/certhub-integration-base/
	# Build images.
	docker build -t certhub-integration-base integration-test/certhub-integration-base
	docker build -t certhub-integration-controller integration-test/certhub-integration-controller
	docker build -t certhub-integration-node integration-test/certhub-integration-node
	docker run --rm -d --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN --name certhub-integration-node certhub-integration-node /sbin/init
	docker run --rm -d --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN --link certhub-integration-node --name certhub-integration-controller certhub-integration-controller /sbin/init
	docker exec certhub-integration-controller bash -c 'ssh-keyscan certhub-integration-node > /etc/ssh/ssh_known_hosts'
	# Run the test
	docker exec certhub-integration-controller systemctl enable certhub-certbot-run@certbot-cert.path
	docker exec certhub-integration-controller systemctl start certhub-certbot-run@certbot-cert.path
	docker exec certhub-integration-controller systemctl enable certhub-repo-push@certhub\\x2dintegration\\x2dnode:-home-certhub-certs.git.path
	docker exec certhub-integration-controller systemctl start certhub-repo-push@certhub\\x2dintegration\\x2dnode:-home-certhub-certs.git.path
	docker exec certhub-integration-controller su -s /bin/sh -c /home/certhub/input/certbot-cert-csr-import.sh - certhub
	# Cleanup
	#docker exec certhub-integration-controller systemctl poweroff
	#docker exec certhub-integration-node systemctl poweroff

.PHONY: \
	all \
	clean \
	dist \
	dist-bin \
	dist-src \
	install \
	install-bin \
	install-doc \
	integration-test \
	lint \
	test \
	uninstall \
