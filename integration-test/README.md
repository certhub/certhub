# Integration tests

Integration tests perform "real" certificate operations using `certbot` and
`dehydrated` against the Let's Encrypt staging infrastructure. A public DNS
service is used to validate the challenge, thus it is not necessary that the
testing infrastructure is reachable from the internet.

## Running

Use `make` to run the tests. Caution: This will build and run the necessary
docker containers. Images are named `certhub-integration-*`.

```
    make all
```

Or run individual tests. E.g.:

```
    make with_tor=1 test-dehydrated
```

## Note: Local integration test setup

Copy the whole `src/github` directory to `src/local` and modify its contents.
In order to identify all files which probably need to be changed use something
like `find src/local -name '*.in'`. The environment can be selected using the
`testenv` variable.

```
    make testenv=local all
```

Note: Docker images are only rebuilt when the docker context changes. It is
necessary to remove `controller/context` after changing anything in the `src`
directory.

## Note: Docker and systemd

Certhub ships with numerous systemd units. In order to really test all of those
components it is desirable to run systemd on the testing infrastructure.
Publicly available CI providers heavily rely on docker and most docker folks
flatout refuse the idea to run systemd inside a container. Luckily official
CentOS images allow running systemd without adventurous customization.
