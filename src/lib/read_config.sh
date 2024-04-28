# shellcheck shell=bash

read_config() {
    local config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/backup"
    local config_file="${config_dir}/config.sh"

    if [ ! -f "${config_file}" ]; then
        mkdir --parent "${config_dir}"
        write_config_template "${config_file}"

        if [ "${EDITOR:-}" = "" ]; then
            log_info "template config file generated at:"
            log_info ""
            log_info "    ${config_file}"
            log_info ""
            log_info "edit this file before continuing"
            exit 1
        else
            "${EDITOR}" "${config_file}"
        fi
    fi

    # shellcheck disable=SC1090  # shellcheck shouldn't lint this file
    source "${config_file}"
}

write_config_template() {
    # shellcheck disable=SC2016  # any dollar signs in the following should be literal
    echo '# shellcheck shell=bash
#
# recommended: all this information should be stored in a password manager. this makes your life
# much easier when it'\''s time to restore data later.
#
export AWS_ACCESS_KEY_ID="TODO"
export AWS_SECRET_ACCESS_KEY="TODO"
export RESTIC_REPOSITORY="s3:https://example.com/bucket-name"
export RESTIC_E2EE_PASSWORD="TODO"

BACKUP_PATHS=(
    # TODO
)

EXCLUDE=(
    "*.lo"
    "*.o"
    "*.pyc"
    "*~"
    ".cache/"
    ".config/"
    ".git/"
    ".gradle/"
    ".idea/"
    ".jdks/"
    ".local/"
    ".npm/"
    ".nvm/"
    ".opam/"
    ".tmp/"
    ".var/"
    ".vscode-oss/extensions/"
    "\$RECYCLE.BIN"
    "Downloads/"
    "gvfs-metadata/"
    "lost+found/"
    "node_modules/"
    "venv/"
)
' > "${1}"
}
