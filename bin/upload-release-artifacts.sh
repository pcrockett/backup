#!/usr/bin/env bash
set -Eeuo pipefail

current_release() {
    grep --only-matching --perl-regexp '(?<="\.":\s")\d+\.\d+\.\d+(?=")' .release-please-manifest.json
}

main() {
    current_release
    gh release upload --clobber "v$(current_release)" ./backup
}

main

