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

Copy the whole `src/travis` directory to `src/local` and modify its contents.
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

## Note: Dehydrated and Tor

Dehydrated uses the `curl` command line utility in order to perform the
necessary API requests. As a result every call will result in a new TCP
connection. This can lead to problems in network environments where the public
IP address is changing between requests as the ACME protocol is
[not really stateless][1].

Some of Travis CI infrastructure is behind a NAT and outgoing connections are
rotated over multiple nodes. Hence traffic is tunneled through the tor network
when testing `dehydrated` in order to work around this issue.

[1]: https://github.com/lukas2511/dehydrated/issues/547
[2]: https://blog.travis-ci.com/2018-07-23-the-tale-of-ftp-at-travis-ci
