# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2024-09-23

## Added
- feat(docs): Deprecate dehydrated integration (#91)
- feat(hooks) Follow CNAME records in nsupdate hook (#84)

## Changed
- fix(ci): Remove deprecated certbot option (#87)
- fix(ci): Remove workaround for buggy CNI plugin (#89)
- fix(ci): Replace rsa with ec in unit tests (#88)
- chore(ci): Disable dehydrated tests (#86)

## [1.2.0] - 2024-03-30

## Added
- fix(systemd): Remove certhub-cert-expiry@.path unit (#75)
- fix(systemd): Cleanup expiry status after renew (#73)

## Changed
- chore(docs): Ensure that plantuml is available (#80)
- chore(ci): Update outdated github action (#79)
- chore(docs): Correct year and rtd theme (#78)
- chore(docs): Correct paths in rtd config (#77)
- chore(docs): Migrate config to rtd v2 (#76)
- chore(ci):  Migrate ci to gh actions (#74)

## [1.1.0] - 2022-04-03

### Added
- feat(lego): Add option to specify preferred chain (#64)

### Changed
- fix(systemd): Remove superflous systemd directive (#67)
- feat(bin): Replace xargs by command shell built-in (#68)
- chore(ci): Update lego to 4.6.0 (#66)
- fix(ci): Install python cryptography from apt sources, use focal (#65)
- chore(docs): Correct mistake in overview.rst. (#58)
- feat(ci): Update go-acem/lego (3.3.0) (#56)
- chore(docs): More details on TLS keys and CSR (#57)
- chore(docs): Wildcard certificates for internal purposes (#55)
- chore(docs): Add DNS-01 best practice section (#54)

## [1.0.0] - 2019-09-24

### Changed
- Various docs and CI updates, no functional changes

## [1.0.0-beta9] - 2019-07-13

## Added
- Support dehydrated 0.6.3 account\_id.json (#39)

## [1.0.0-beta8] - 2019-07-04

## Added
- Allow to customize systemctl reload command (#38)
- Add certhub-send-file command (#43)
- Add certhub-cert-send service with configurable destinations (#42)

## [1.0.0-beta7] - 2019-05-09
## Changed
- Run acme client whenever CSR file changed (#36)

## [1.0.0-beta6] - 2019-04-17
## Added
- Docker entry script for acme-dns registration (#34)

## [1.0.0-beta5] - 2019-04-01
### Changed
- Add missing package to github release stage (#30)

## [1.0.0-beta4] - 2019-04-01
### Added
- Add docker support via git-gau (#28)
- Add an overview section to the users guide (#24)

### Changed
- Make sure lego certificates directory exists (#27)
- Update to git-gau v1.1.0 (#26)
- Support lego 2.4.0 (#25)

## [1.0.0-beta3] - 2018-12-28
### Added
- Added users guide and publish it on https://certhub.readthedocs.org/
- Added man pages for systemd units (#16)
- Added man pages for lexicon and nsupdate hooks (#18 and #23)

### Changed
- Normalized environment variable names (#15 and #17)
- Add optional environment files (#19)
- Use per-service environment files for certbot / dehydrated configuration (#21)

### Removed
- Remove %i.lego.args file and `CERTHUB_LEGO_CONFIG` variable (#20)

## [1.0.0-beta2] - 2018-12-18
### Added
- Fix automatic releases.

## 1.0.0-beta1 - 2018-12-18
### Added
- Initial release.

[Unreleased]: https://github.com/certhub/certhub/compare/v1.3.0...HEAD
[1.3.0]: https://github.com/certhub/certhub/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/certhub/certhub/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/certhub/certhub/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/certhub/certhub/compare/v1.0.0-beta9...v1.0.0
[1.0.0-beta9]: https://github.com/certhub/certhub/compare/v1.0.0-beta8...v1.0.0-beta9
[1.0.0-beta8]: https://github.com/certhub/certhub/compare/v1.0.0-beta7...v1.0.0-beta8
[1.0.0-beta7]: https://github.com/certhub/certhub/compare/v1.0.0-beta6...v1.0.0-beta7
[1.0.0-beta6]: https://github.com/certhub/certhub/compare/v1.0.0-beta5...v1.0.0-beta6
[1.0.0-beta5]: https://github.com/certhub/certhub/compare/v1.0.0-beta4...v1.0.0-beta5
[1.0.0-beta4]: https://github.com/certhub/certhub/compare/v1.0.0-beta3...v1.0.0-beta4
[1.0.0-beta3]: https://github.com/certhub/certhub/compare/v1.0.0-beta2...v1.0.0-beta3
[1.0.0-beta2]: https://github.com/certhub/certhub/compare/v1.0.0-beta1...v1.0.0-beta2
