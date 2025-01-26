# Changelog

## [0.2.7](https://github.com/pcrockett/backup/compare/v0.2.6...v0.2.7) (2025-01-26)


### Features

* **config:** better instructions to find filesystem UUID ([#48](https://github.com/pcrockett/backup/issues/48)) ([b5a0159](https://github.com/pcrockett/backup/commit/b5a0159bb2fba4477100285ec6416e47970c0b2f))


### Bug Fixes

* **automagic:** render "${?}" in automagic script instead of "0" ([#50](https://github.com/pcrockett/backup/issues/50)) ([1dd68de](https://github.com/pcrockett/backup/commit/1dd68deda98f5a1ffab9ecbbd4cddee9e316aa98))

## [0.2.6](https://github.com/pcrockett/backup/compare/v0.2.5...v0.2.6) (2024-12-26)


### Bug Fixes

* **config:** restrict default permissions ([#45](https://github.com/pcrockett/backup/issues/45)) ([d652166](https://github.com/pcrockett/backup/commit/d652166b4b101f4dac556600c73b68ef9df827fa))

## [0.2.5](https://github.com/pcrockett/backup/compare/v0.2.4...v0.2.5) (2024-11-11)


### Bug Fixes

* **ci:** libffi error ([#44](https://github.com/pcrockett/backup/issues/44)) ([caf1507](https://github.com/pcrockett/backup/commit/caf150798fafc4be01b18e7ff7efc9e959651e76))
* **ci:** minio start race condition on slower devices ([#41](https://github.com/pcrockett/backup/issues/41)) ([933e110](https://github.com/pcrockett/backup/commit/933e110c20db6d48c3a421d8ea22aead74b1b9d4))

## [0.2.4](https://github.com/pcrockett/backup/compare/v0.2.3...v0.2.4) (2024-09-15)


### Bug Fixes

* make sure all traps run ([#39](https://github.com/pcrockett/backup/issues/39)) ([00c35f4](https://github.com/pcrockett/backup/commit/00c35f4c8da048ccd028c4e82e45d6d175663ab3))

## [0.2.3](https://github.com/pcrockett/backup/compare/v0.2.2...v0.2.3) (2024-09-15)


### Features

* automagic backup hooks ([#36](https://github.com/pcrockett/backup/issues/36)) ([ee0fca3](https://github.com/pcrockett/backup/commit/ee0fca3128799a0db4e2acbfd7edf2690e9fc599))


### Bug Fixes

* ignore list tweaks ([#37](https://github.com/pcrockett/backup/issues/37)) ([3c9b35b](https://github.com/pcrockett/backup/commit/3c9b35b358b3ba2108cd03df969d23eb9d25d777))

## [0.2.2](https://github.com/pcrockett/backup/compare/v0.2.1...v0.2.2) (2024-08-30)


### Features

* populate config with user home directories ([#35](https://github.com/pcrockett/backup/issues/35)) ([1afb0f5](https://github.com/pcrockett/backup/commit/1afb0f5550dc9eaed452985b350007dbc5076cdb))


### Bug Fixes

* automagic script not executable ([#33](https://github.com/pcrockett/backup/issues/33)) ([8af7f21](https://github.com/pcrockett/backup/commit/8af7f21cf7bf868908309bb3283011cdf4cf68f3))

## [0.2.1](https://github.com/pcrockett/backup/compare/v0.2.0...v0.2.1) (2024-08-26)


### Features

* automagically backup when external drive is connected ([#32](https://github.com/pcrockett/backup/issues/32)) ([29f2480](https://github.com/pcrockett/backup/commit/29f2480ef9b5f9182f499105a0c8d3cd60a91fed))
* more friendly external device not found message ([#29](https://github.com/pcrockett/backup/issues/29)) ([c3e69d0](https://github.com/pcrockett/backup/commit/c3e69d0edffd7bcf2924a89e2b1be8fe476a6eb1))


### Bug Fixes

* **ci:** prevent apt from cleaning up download cache ([#31](https://github.com/pcrockett/backup/issues/31)) ([ab07bed](https://github.com/pcrockett/backup/commit/ab07bed8c27adaeab5af504b0569a51b9aaa3270))

## [0.2.0](https://github.com/pcrockett/backup/compare/v0.1.3...v0.2.0) (2024-08-25)


### ⚠ BREAKING CHANGES

* move config etc to system dirs ([#28](https://github.com/pcrockett/backup/issues/28))

### Features

* only run as root ([#25](https://github.com/pcrockett/backup/issues/25)) ([a6f5c63](https://github.com/pcrockett/backup/commit/a6f5c63318e1f17a00b4a18a04a03b7ce80773e8))


### Bug Fixes

* move config etc to system dirs ([#28](https://github.com/pcrockett/backup/issues/28)) ([6c3ca91](https://github.com/pcrockett/backup/commit/6c3ca919ed2c5faca4546f3d1424d23d205b8155))

## [0.1.3](https://github.com/pcrockett/backup/compare/v0.1.2...v0.1.3) (2024-08-18)


### Bug Fixes

* **release:** missed a dollar sign ([#22](https://github.com/pcrockett/backup/issues/22)) ([6e4a465](https://github.com/pcrockett/backup/commit/6e4a465f25f5c372bbe751986cf7dcdf0b4ae871))
* **release:** upload artifact after release-please in same workflow ([#19](https://github.com/pcrockett/backup/issues/19)) ([5aebf8a](https://github.com/pcrockett/backup/commit/5aebf8ab435f3b9fe796c574e1ec03b6d4318ad7))
* **release:** upload artifacts after release ([#21](https://github.com/pcrockett/backup/issues/21)) ([da73590](https://github.com/pcrockett/backup/commit/da73590bf2f84fd806dd844ed0203378c8630571))

## [0.1.2](https://github.com/pcrockett/backup/compare/v0.1.1...v0.1.2) (2024-08-18)


### Bug Fixes

* **release:** trigger workflow on publish ([#17](https://github.com/pcrockett/backup/issues/17)) ([f74944c](https://github.com/pcrockett/backup/commit/f74944ce8f3765e70a7a2e3da3a5aaf08eb4d8dc))

## [0.1.1](https://github.com/pcrockett/backup/compare/v0.1.0...v0.1.1) (2024-08-18)


### Miscellaneous Chores

* **docs:** document how releases work ([#11](https://github.com/pcrockett/backup/issues/11)) ([d1f28d5](https://github.com/pcrockett/backup/commit/d1f28d5dfd34851dab23ca732867eb4a20cf8eae))

## 0.1.0 (2024-08-18)


### Bug Fixes

* prevent new traps from blowing away existing traps ([afe180e](https://github.com/pcrockett/backup/commit/afe180e34c4b952585998efeef4de836dd4df9d5))


### Code Refactoring

* **ci:** Test inside docker ([#5](https://github.com/pcrockett/backup/issues/5)) ([42048e6](https://github.com/pcrockett/backup/commit/42048e6301d58246ce5739568e0663fa5aa4d462))
