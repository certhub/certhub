# certhub - Centralized certificate management the unix way

A collection of scripts, systemd units and docker images which make it easy to
setup centralized TLS certificate management with git as a backend.

[![Build Status](https://github.com/certhub/certhub/actions/workflows/on-push.yml/badge.svg)](https://github.com/certhub/certhub/actions/workflows/on-push.yml)

## DEPENDENCIES

The executables provided by certhub only depend on `openssl` and any of the
following supported ACME clients: [Certbot], [Dehydrated] or [Lego].  Certhub
includes DNS-01 challenge hooks for `nsupdate` and [Lexicon].

In order to use the systemd units, `git` and [git-gau] is required.

## DOCS AND MANPAGES

* https://certhub.readthedocs.io/

## DOCKER IMAGES

* https://hub.docker.com/r/certhub/certhub

## INSTALL

Navigate to the releases page and pick the latest `certhub-dist.tar.gz`
tarball. Copy it to the target machine and unpack it there.

    $ scp dist/certhub-dist.tar.gz me@example.com:~
    $ ssh me@example.com sudo tar -C /usr/local -xzf ~/certhub-dist.tar.gz

## BUILD

*Preferred method*: Build a distribution tarball, copy it to the target machine
and unpack it there.

    $ make dist
    $ scp dist/certhub-dist.tar.gz me@example.com:~
    $ ssh me@example.com sudo tar -C /usr/local -xzf ~:certhub-dist.tar.gz

*Alternative method*: Check out this repository on the traget machine and
install it directly. The destination directory can be changed with the `prefix`
variable in order to change the installation prefix to something else than
`/usr/local`.

    $ make all
    $ sudo make prefix=/opt/local install

[Sphinx] is necessary in order to build the man pages and the users guide. This
step can be skipped by using the `install-bin` target.

[Certbot]: https://certbot.eff.org/
[Dehydrated]: https://dehydrated.io/
[Lego]: https://github.com/go-acme/lego
[Lexicon]: https://github.com/AnalogJ/lexicon
[git-gau]: https://github.com/znerol/git-gau
[Sphinx]: https://www.sphinx-doc.org/
