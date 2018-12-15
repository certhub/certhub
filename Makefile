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
	shellcheck bin/certhub-cert-expiry
	shellcheck bin/certhub-certbot-run
	shellcheck bin/certhub-dehydrated-run
	shellcheck bin/certhub-lego-run
	shellcheck bin/certhub-message-format
	shellcheck bin/certhub-status-file
	shellcheck lib/certbot-hooks/lexicon-auth
	shellcheck lib/certbot-hooks/nsupdate-auth
	shellcheck lib/dehydrated-hooks/lexicon-auth
	shellcheck lib/dehydrated-hooks/nsupdate-auth

test: bin
	PATH="$(shell pwd)/bin:${PATH}" $(python) -m test

doc: \
	doc/certhub-cert-expiry.1 \
	doc/certhub-certbot-run.1 \
	doc/certhub-dehydrated-run.1 \
	doc/certhub-lego-run.1 \
	doc/certhub-message-format.1 \
	doc/certhub-status-file.1

clean:
	-rm -f doc/certhub-cert-expiry.1
	-rm -f doc/certhub-certbot-run.1
	-rm -f doc/certhub-dehydrated-run.1
	-rm -f doc/certhub-lego-run.1
	-rm -f doc/certhub-message-format.1
	-rm -f doc/certhub-status-file.1
	-rm -rf dist
	-rm -rf build

install-doc: doc
	install -m 0644 -D doc/certhub-cert-expiry.1 $(DESTDIR)$(mandir)/man1/certhub-cert-expiry.1
	install -m 0644 -D doc/certhub-certbot-run.1 $(DESTDIR)$(mandir)/man1/certhub-certbot-run.1
	install -m 0644 -D doc/certhub-dehydrated-run.1 $(DESTDIR)$(mandir)/man1/certhub-dehydrated-run.1
	install -m 0644 -D doc/certhub-lego-run.1 $(DESTDIR)$(mandir)/man1/certhub-lego-run.1
	install -m 0644 -D doc/certhub-message-format.1 $(DESTDIR)$(mandir)/man1/certhub-message-format.1
	install -m 0644 -D doc/certhub-status-file.1 $(DESTDIR)$(mandir)/man1/certhub-status-file.1

install-bin: bin
	install -m 0755 -D bin/certhub-cert-expiry $(DESTDIR)$(bindir)/certhub-cert-expiry
	install -m 0755 -D bin/certhub-certbot-run $(DESTDIR)$(bindir)/certhub-certbot-run
	install -m 0755 -D bin/certhub-dehydrated-run $(DESTDIR)$(bindir)/certhub-dehydrated-run
	install -m 0755 -D bin/certhub-lego-run $(DESTDIR)$(bindir)/certhub-lego-run
	install -m 0755 -D bin/certhub-message-format $(DESTDIR)$(bindir)/certhub-message-format
	install -m 0755 -D bin/certhub-status-file $(DESTDIR)$(bindir)/certhub-status-file
	install -m 0755 -D lib/certbot-hooks/lexicon-auth $(DESTDIR)$(libdir)/certhub/certbot-hooks/lexicon-auth
	ln -s -f lexicon-auth $(DESTDIR)$(libdir)/certhub/certbot-hooks/lexicon-cleanup
	install -m 0755 -D lib/certbot-hooks/nsupdate-auth $(DESTDIR)$(libdir)/certhub/certbot-hooks/nsupdate-auth
	ln -s -f nsupdate-auth $(DESTDIR)$(libdir)/certhub/certbot-hooks/nsupdate-cleanup
	install -m 0755 -D lib/dehydrated-hooks/lexicon-auth $(DESTDIR)$(libdir)/certhub/dehydrated-hooks/lexicon-auth
	install -m 0755 -D lib/dehydrated-hooks/nsupdate-auth $(DESTDIR)$(libdir)/certhub/dehydrated-hooks/nsupdate-auth
	install -m 0644 -D lib/systemd/certhub-cert-expiry@.path $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.path
	install -m 0644 -D lib/systemd/certhub-cert-expiry@.service $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.service
	install -m 0644 -D lib/systemd/certhub-cert-expiry@.service.d/expiry.conf $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.service.d/expiry.conf
	install -m 0644 -D lib/systemd/certhub-cert-expiry@.timer $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.timer
	install -m 0644 -D lib/systemd/certhub-cert-export@.path $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.path
	install -m 0644 -D lib/systemd/certhub-cert-export@.service $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.service
	install -m 0644 -D lib/systemd/certhub-cert-export@.service.d/export.conf $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.service.d/export.conf
	install -m 0644 -D lib/systemd/certhub-cert-reload@.path $(DESTDIR)$(systemdsystemdir)/certhub-cert-reload@.path
	install -m 0644 -D lib/systemd/certhub-cert-reload@.service $(DESTDIR)$(systemdsystemdir)/certhub-cert-reload@.service
	install -m 0644 -D lib/systemd/certhub-cert-reload@.service.d/reload.conf $(DESTDIR)$(systemdsystemdir)/certhub-cert-reload@.service.d/reload.conf
	install -m 0644 -D lib/systemd/certhub-certbot-run@.path $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.path
	install -m 0644 -D lib/systemd/certhub-certbot-run@.service $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service
	install -m 0644 -D lib/systemd/certhub-certbot-run@.service.d/certbot.conf $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/certbot.conf
	install -m 0644 -D lib/systemd/certhub-dehydrated-run@.path $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.path
	install -m 0644 -D lib/systemd/certhub-dehydrated-run@.service $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service
	install -m 0644 -D lib/systemd/certhub-dehydrated-run@.service.d/dehydrated.conf $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/dehydrated.conf
	install -m 0644 -D lib/systemd/certhub-lego-run@.path $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.path
	install -m 0644 -D lib/systemd/certhub-lego-run@.service $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service
	install -m 0644 -D lib/systemd/certhub-lego-run@.service.d/lego-challenge.conf $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d/lego-challenge.conf
	install -m 0644 -D lib/systemd/certhub-lego-run@.service.d/lego.conf $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d/lego.conf
	install -m 0644 -D lib/systemd/certhub-repo-push@.path $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.path
	install -m 0644 -D lib/systemd/certhub-repo-push@.service $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.service
	install -m 0644 -D lib/systemd/certhub-repo-push@.service.d/remote.conf $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.service.d/remote.conf
	# Shared systemd unit drop-ins for cert-expiry
	install -m 0644 -D lib/systemd/certhub-shared.d/repo.conf $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.service.d/repo.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/user.conf $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.service.d/user.conf
	# Shared systemd unit drop-ins for cert-export
	install -m 0644 -D lib/systemd/certhub-shared.d/repo.conf $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.service.d/repo.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/user.conf $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.service.d/user.conf
	# Shared systemd unit drop-ins for cert-reload: None
	# Shared systemd unit drop-ins for certbot
	install -m 0644 -D lib/systemd/certhub-shared.d/commit.conf $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/commit.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/csr.conf $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/csr.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/hook-lexicon-auth.conf $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/hook-lexicon-auth.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/hook-nsupdate-auth.conf $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/hook-nsupdate-auth.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/repo.conf $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/repo.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/user.conf $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/user.conf
	# Shared systemd unit drop-ins for dehydrated
	install -m 0644 -D lib/systemd/certhub-shared.d/commit.conf $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/commit.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/csr.conf $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/csr.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/hook-lexicon-auth.conf $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/hook-lexicon-auth.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/hook-nsupdate-auth.conf $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/hook-nsupdate-auth.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/repo.conf $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/repo.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/user.conf $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/user.conf
	# Shared systemd unit drop-ins for lego
	install -m 0644 -D lib/systemd/certhub-shared.d/commit.conf $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d/commit.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/csr.conf $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d/csr.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/repo.conf $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d/repo.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/user.conf $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d/user.conf
	# Shared systemd unit drop-ins for repo-push
	install -m 0644 -D lib/systemd/certhub-shared.d/repo.conf $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.service.d/repo.conf
	install -m 0644 -D lib/systemd/certhub-shared.d/user.conf $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.service.d/user.conf

install: install-bin install-doc

uninstall:
	-rm -f $(DESTDIR)$(bindir)/certhub-cert-expiry
	-rm -f $(DESTDIR)$(bindir)/certhub-certbot-run
	-rm -f $(DESTDIR)$(bindir)/certhub-dehydrated-run
	-rm -f $(DESTDIR)$(bindir)/certhub-lego-run
	-rm -f $(DESTDIR)$(bindir)/certhub-message-format
	-rm -f $(DESTDIR)$(bindir)/certhub-status-file
	-rm -f $(DESTDIR)$(libdir)/certhub/certbot-hooks/lexicon-auth
	-rm -f $(DESTDIR)$(libdir)/certhub/certbot-hooks/lexicon-cleanup
	-rm -f $(DESTDIR)$(libdir)/certhub/certbot-hooks/nsupdate-auth
	-rm -f $(DESTDIR)$(libdir)/certhub/certbot-hooks/nsupdate-cleanup
	-rm -f $(DESTDIR)$(libdir)/certhub/dehydrated-hooks/lexicon-auth
	-rm -f $(DESTDIR)$(libdir)/certhub/dehydrated-hooks/nsupdate-auth
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-cert-expiry.1
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-certbot-run.1
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-dehydrated-run.1
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-lego-run.1
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-message-format.1
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-status-file.1
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.service.d/expiry.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.service.d/repo.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.service.d/user.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.timer
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.service.d/export.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.service.d/repo.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.service.d/user.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-reload@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-reload@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-cert-reload@.service.d/reload.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/certbot.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/commit.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/csr.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/hook-lexicon-auth.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/hook-nsupdate-auth.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/repo.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d/user.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/commit.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/csr.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/dehydrated.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/hook-lexicon-auth.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/hook-nsupdate-auth.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/repo.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d/user.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d/commit.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d/csr.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d/lego-challenge.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d/lego.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d/repo.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d/user.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.path
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.service
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.service.d/remote.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.service.d/repo.conf
	-rm -f $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.service.d/user.conf
	-rmdir $(DESTDIR)$(systemdsystemdir)/certhub-cert-expiry@.service.d
	-rmdir $(DESTDIR)$(systemdsystemdir)/certhub-cert-export@.service.d
	-rmdir $(DESTDIR)$(systemdsystemdir)/certhub-cert-reload@.service.d
	-rmdir $(DESTDIR)$(systemdsystemdir)/certhub-certbot-run@.service.d
	-rmdir $(DESTDIR)$(systemdsystemdir)/certhub-dehydrated-run@.service.d
	-rmdir $(DESTDIR)$(systemdsystemdir)/certhub-lego-run@.service.d
	-rmdir $(DESTDIR)$(systemdsystemdir)/certhub-repo-push@.service.d

dist-bin:
	-rm -rf build
	${MAKE} DESTDIR=build prefix=/ install
	mkdir -p dist
	tar --owner=root:0 --group=root:0 -czf dist/certhub-dist.tar.gz -C build .

dist-src:
	mkdir -p dist
	git archive -o dist/certhub-src.tar.gz HEAD

dist: dist-src dist-bin

integration-test: dist
	${MAKE} -C integration-test all

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
