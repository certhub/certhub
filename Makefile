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

man1 := $(patsubst doc/%.1.rst,doc/_build/man/%.1,$(wildcard doc/*.1.rst))
man1_installed := $(patsubst doc/_build/man/%,$(DESTDIR)$(mandir)/man1/%,$(man1))
man8 := $(patsubst doc/%.8.rst,doc/_build/man/%.8,$(wildcard doc/*.8.rst))
man8_installed := $(patsubst doc/_build/man/%,$(DESTDIR)$(mandir)/man8/%,$(man8))

scriptdirs := bin $(wildcard lib/*hooks)
scripts := $(foreach dir,$(scriptdirs),$(wildcard $(dir)/*))
scripts_installed := \
    $(patsubst bin/%,$(DESTDIR)$(bindir)/%,$(filter bin/%,$(scripts))) \
    $(patsubst lib/%,$(DESTDIR)$(libdir)/certhub/%,$(filter lib/%,$(scripts)))

entrypointdirs := lib/docker-entry.d
entrypoints := $(foreach dir,$(entrypointdirs),$(wildcard $(dir)/*))
entrypoints_installed := \
    $(patsubst lib/%,$(DESTDIR)$(libdir)/git-gau/%,$(entrypoints))

units := \
    $(wildcard lib/systemd/*.service) \
    $(wildcard lib/systemd/*.path) \
    $(wildcard lib/systemd/*.timer)
units_installed := \
    $(patsubst lib/systemd/%,$(DESTDIR)$(systemdsystemdir)/%,$(units))

dropindirs := \
    $(wildcard lib/systemd/*.service.d) \
    $(wildcard lib/systemd/*.path.d) \
    $(wildcard lib/systemd/*.timer.d)
dropindirs_installed := \
    $(patsubst lib/systemd/%,$(DESTDIR)$(systemdsystemdir)/%,$(dropindirs))

dropins := $(foreach dir,$(dropindirs),$(wildcard $(dir)/*.conf))
dropins_installed := \
    $(patsubst lib/systemd/%,$(DESTDIR)$(systemdsystemdir)/%,$(dropins))

doc/_build/man/% : doc/%.rst
	${MAKE} -C doc man

bin: $(scripts) $(entrypoints)
	# empty for now

lint: bin
	shellcheck $(scripts) $(entrypoints)

test: bin
	PATH="$(shell pwd)/bin:${PATH}" $(python) -m test

doc: $(man1) $(man8)

clean:
	${MAKE} -C doc clean
	-rm -rf dist
	-rm -rf build

# Install rule for executables/scripts
$(DESTDIR)$(bindir)/% : bin/%
	install -m 0755 -D $< $@

# Install rule for hook scripts
$(DESTDIR)$(libdir)/certhub/% : lib/%
	install -m 0755 -D $< $@

# Install rule for entrypoint scripts
$(DESTDIR)$(libdir)/git-gau/docker-entry.d/% : lib/docker-entry.d/%
	install -m 0755 -D $< $@

# Install rule for systemd units and dropins
$(DESTDIR)$(systemdsystemdir)/%: lib/systemd/%
	install -m 0644 -D $< $@

# Install rule for manpages
$(DESTDIR)$(mandir)/man1/% : doc/_build/man/%
	install -m 0644 -D $< $@

# Install rule for manpages
$(DESTDIR)$(mandir)/man8/% : doc/_build/man/%
	install -m 0644 -D $< $@

install-doc: doc $(man1_installed) $(man8_installed)
	ln -s -f certhub-lego-run.1 $(DESTDIR)$(mandir)/man1/certhub-lego-run-preferred-chain.1
	ln -s -f certhub-certbot-run@.service.8 $(DESTDIR)$(mandir)/man8/certhub-certbot-run@.path.8
	ln -s -f certhub-lego-run@.service.8 $(DESTDIR)$(mandir)/man8/certhub-lego-run@.path.8
	ln -s -f certhub-dehydrated-run@.service.8 $(DESTDIR)$(mandir)/man8/certhub-dehydrated-run@.path.8
	ln -s -f certhub-cert-expiry@.service.8 $(DESTDIR)$(mandir)/man8/certhub-cert-expiry@.path.8
	ln -s -f certhub-cert-expiry@.service.8 $(DESTDIR)$(mandir)/man8/certhub-cert-expiry@.timer.8
	ln -s -f certhub-cert-export@.service.8 $(DESTDIR)$(mandir)/man8/certhub-cert-export@.path.8
	ln -s -f certhub-cert-reload@.service.8 $(DESTDIR)$(mandir)/man8/certhub-cert-reload@.path.8
	ln -s -f certhub-cert-send@.service.8 $(DESTDIR)$(mandir)/man8/certhub-cert-send@.path.8
	ln -s -f certhub-repo-push@.service.8 $(DESTDIR)$(mandir)/man8/certhub-repo-push@.path.8

install-bin: bin $(scripts_installed) $(entrypoints_installed) $(units_installed) $(dropins_installed)
	ln -s -f lexicon-auth $(DESTDIR)$(libdir)/certhub/certbot-hooks/lexicon-cleanup
	ln -s -f nsupdate-auth $(DESTDIR)$(libdir)/certhub/certbot-hooks/nsupdate-cleanup

install: install-bin install-doc

uninstall:
	-rm -f $(man1_installed)
	-rm -f $(man8_installed)
	-rm -f $(scripts_installed)
	-rm -f $(entrypoints_installed)
	-rm -f $(units_installed)
	-rm -f $(dropins_installed)
	-rmdir $(dropindirs_installed)
	-rm -f $(DESTDIR)$(mandir)/man1/certhub-lego-run-preferred-chain.1
	-rm -f $(DESTDIR)$(mandir)/man8/certhub-cert-expiry@.path.8
	-rm -f $(DESTDIR)$(mandir)/man8/certhub-cert-expiry@.timer.8
	-rm -f $(DESTDIR)$(mandir)/man8/certhub-cert-export@.path.8
	-rm -f $(DESTDIR)$(mandir)/man8/certhub-cert-reload@.path.8
	-rm -f $(DESTDIR)$(mandir)/man8/certhub-cert-send@.path.8
	-rm -f $(DESTDIR)$(mandir)/man8/certhub-certbot-run@.path.8
	-rm -f $(DESTDIR)$(mandir)/man8/certhub-dehydrated-run@.path.8
	-rm -f $(DESTDIR)$(mandir)/man8/certhub-lego-run@.path.8
	-rm -f $(DESTDIR)$(mandir)/man8/certhub-repo-push@.path.8
	-rm -f $(DESTDIR)$(libdir)/certhub/certbot-hooks/lexicon-cleanup
	-rm -f $(DESTDIR)$(libdir)/certhub/certbot-hooks/nsupdate-cleanup
	-rmdir $(DESTDIR)$(libdir)/certhub/dehydrated-hooks
	-rmdir $(DESTDIR)$(libdir)/certhub/certbot-hooks
	-rmdir $(DESTDIR)$(libdir)/certhub

dist-bin:
	-rm -rf build
	${MAKE} DESTDIR=build prefix=/ install
	mkdir -p dist
	tar --owner=root:0 --group=root:0 -czf dist/certhub-dist.tar.gz -C build .

dist-src:
	mkdir -p dist
	git archive -o dist/certhub-src.tar.gz HEAD

dist: dist-src dist-bin
	cd dist && md5sum certhub-*.tar.gz > md5sum.txt
	cd dist && sha1sum certhub-*.tar.gz > sha1sum.txt
	cd dist && sha256sum certhub-*.tar.gz > sha256sum.txt

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
