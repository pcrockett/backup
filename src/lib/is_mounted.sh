# shellcheck shell=bash

is_mounted() {
    local dir_path="${1}"
    findmnt --raw --noheadings --output TARGET "${dir_path}" > /dev/null
}
