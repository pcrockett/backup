## [0.4.1] - 2026-03-27

### 🐛 Bug Fixes

* *(automagic)* Prevent hooks from taking stdin (#82)

### ⚙️ Miscellaneous Tasks

* *(ci)* Update to yolo script v2 (#81)

## [0.4.0] - 2026-03-12

### 🚀 Features

* *(config)* Add to default exclude list (#78)

## [0.3.0] - 2025-12-25

### 🚀 Features

* Forget and prune old snapshots

### 🐛 Bug Fixes

* *(ci)* Speed up gitleaks and actionlint steps
* *(ci)* Use system shellcheck, not docker
* *(ci)* Remove gitleaks

### ⚙️ Miscellaneous Tasks

* *(ci)* Add tagref checks
* Simplify .editorconfig and shfmt config
* *(ci)* Pre-commit
* Better shfmt line wrapping
* *(ci)* Eliminate cue, just use yaml
* Set github token when working on project
* *(ci)* Update pre-commit, yaml quality gates
* *(ci)* Fix missing yamlfmt
* *(ci)* Yamlfmt from asdf
* *(ci)* Update to latest boilerplate
* *(ci)* Update gh actions
* *(ci)* Update github actions

## [0.2.10] - 2025-09-06

### ⚙️ Miscellaneous Tasks

* Bump actions/checkout from 4 to 5 (#69)
* Bump amannn/action-semantic-pull-request from 5.5.3 to 6.0.1 (#70)
* *(ci)* Update / comment gh action version

## [0.2.9] - 2025-08-11

### 🐛 Bug Fixes

* Lint error introduced by upstream change (#59)

### 🚜 Refactor

* Release infra (#67)

### ⚙️ Miscellaneous Tasks

* *(ci)* Use my asdf-shellcheck fork (#53)
* *(ci)* Dockerfile update (#55)
* Bump googleapis/release-please-action from 4.1.3 to 4.1.4 (#54)
* Makefile `pull` target to pull docker images (#56)
* Bump googleapis/release-please-action from 4.1.4 to 4.2.0 (#57)
* *(ci)* Update bashly, cue, ruby / debian (#58)
* *(ci)* Shfmt (#61)
* *(ci)* Authenticate github requests (#63)
* Format source code, not just build outputs (#62)
* Add lsp directive to settings file (#64)
* Format source with shfmt (#65)
* Add format commit to .git-blame-ignore-revs (#66)

## [0.2.8] - 2025-01-27

### 🚀 Features

* *(colors)* Use bashly colors lib (#51)

### ⚙️ Miscellaneous Tasks

* *(main)* Release 0.2.8 (#52)

## [0.2.7] - 2025-01-26

### 🚀 Features

* *(config)* Better instructions to find filesystem UUID (#48)

### 🐛 Bug Fixes

* *(automagic)* Render "${?}" in automagic script instead of "0" (#50)

### ⚙️ Miscellaneous Tasks

* *(main)* Release 0.2.7 (#49)

## [0.2.6] - 2024-12-26

### 🐛 Bug Fixes

* *(config)* Restrict default permissions (#45)

### ⚙️ Miscellaneous Tasks

* *(main)* Release 0.2.6 (#46)

## [0.2.5] - 2024-11-11

### 🐛 Bug Fixes

* *(ci)* Minio start race condition on slower devices (#41)
* *(ci)* Libffi error (#44)

### ⚙️ Miscellaneous Tasks

* *(main)* Release 0.2.5 (#42)

## [0.2.4] - 2024-09-15

### 🐛 Bug Fixes

* Make sure all traps run (#39)

### ⚙️ Miscellaneous Tasks

* *(main)* Release 0.2.4 (#40)

## [0.2.3] - 2024-09-15

### 🚀 Features

* Automagic backup hooks (#36)

### 🐛 Bug Fixes

* Ignore list tweaks (#37)

### ⚙️ Miscellaneous Tasks

* *(main)* Release 0.2.3 (#38)

## [0.2.2] - 2024-08-30

### 🚀 Features

* Populate config with user home directories (#35)

### 🐛 Bug Fixes

* Automagic script not executable (#33)

### ⚙️ Miscellaneous Tasks

* *(main)* Release 0.2.2 (#34)

## [0.2.1] - 2024-08-26

### 🚀 Features

* More friendly external device not found message (#29)
* Automagically backup when external drive is connected (#32)

### 🐛 Bug Fixes

* *(ci)* Prevent apt from cleaning up download cache (#31)

### ⚙️ Miscellaneous Tasks

* *(main)* Release 0.2.1 (#30)

## [0.2.0] - 2024-08-25

### 🚀 Features

* Only run as root (#25)

### 🐛 Bug Fixes

* [**breaking**] Move config etc to system dirs (#28)

### 🚜 Refactor

* Remove compose, simplify docker / devenv (#24)
* *(ci)* Optimize dockerfile (#27)

### ⚙️ Miscellaneous Tasks

* *(docs)* Add more instructions for release management (#23)
* *(main)* Release 0.2.0 (#26)

## [0.1.3] - 2024-08-18

### 🐛 Bug Fixes

* *(release)* Upload artifact after release-please in same workflow (#19)
* *(release)* Upload artifacts after release (#21)
* *(release)* Missed a dollar sign (#22)

### ⚙️ Miscellaneous Tasks

* *(main)* Release 0.1.3 (#20)

## [0.1.2] - 2024-08-18

### 🐛 Bug Fixes

* *(release)* Trigger workflow on publish (#17)

### ⚙️ Miscellaneous Tasks

* *(main)* Release 0.1.2 (#18)

## [0.1.1] - 2024-08-18

### ⚙️ Miscellaneous Tasks

* *(docs)* Document how releases work (#11)
* *(docs)* Update README to point to latest release (#13)
* *(main)* Release 0.1.1 (#15)

## [0.1.0] - 2024-08-18

### 🐛 Bug Fixes

* Prevent new traps from blowing away existing traps

### 💼 Other

* Run command
* Begin work on checking specific file

### 🚜 Refactor

* Reduce duplication of password file logic
* Simplify YAML setup (#4)
* *(ci)* Test inside docker (#5)

### ⚙️ Miscellaneous Tasks

* *(ci)* Release and full CI workflow (#1)
* *(tests)* Add more "check" tests (#3)
* Update build dependencies (#6)
* *(main)* Release 0.1.0 (#2)
