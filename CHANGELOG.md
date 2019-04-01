# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- ...

## [1.0.0-beta5] - 2019-04-01
### Changed
- Add missing package to github release stage #30

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

[Unreleased]: https://github.com/znerol/certhub/compare/v1.0.0-beta5...HEAD
[1.0.0-beta5]: https://github.com/znerol/certhub/compare/v1.0.0-beta4...v1.0.0-beta5
[1.0.0-beta4]: https://github.com/znerol/certhub/compare/v1.0.0-beta3...v1.0.0-beta4
[1.0.0-beta3]: https://github.com/znerol/certhub/compare/v1.0.0-beta2...v1.0.0-beta3
[1.0.0-beta2]: https://github.com/znerol/certhub/compare/v1.0.0-beta1...v1.0.0-beta2
