#!/usr/bin/env bash
set -Eeuo pipefail

current_release() {
    grep --only-matching --perl-regexp '(?<="\.":\s")\d+\.\d+\.\d+(?=")' .release-please-manifest.json
}

asset_count() {
    gh release view --json assets --jq '.assets | length' "v${1}" || echo ""
}

main() {
    local current_release_version current_release_asset_count
    current_release_version="$(current_release)"
    current_release_asset_count="$(asset_count "${current_release_version}")"

    if [ "${current_release_asset_count}" == "" ]; then
        echo "Release v${current_release_version} hasn't been created yet. Nothing to upload."
    elif [ "${current_release_asset_count}" -eq 0 ]; then
        gh release upload "v${current_release_version}" ./backup
    else
        echo "Release v${current_release_version} already has assets. No need to upload anything new."
    fi
}

main

