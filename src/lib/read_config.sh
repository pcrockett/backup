# shellcheck shell=bash

read_config() {
    local config_file="${XDG_CONFIG_HOME:-${HOME}/.config}/backup/config.sh"
    # shellcheck disable=SC1090  # shellcheck shouldn't lint this file
    source "${config_file}"
}
