# shellcheck shell=bash

config_dir() {
    echo "${XDG_CONFIG_HOME:-${HOME}/.config}/backup"
}

config_path() {
    echo "$(config_dir)/config.sh"
}

read_config() {
    local config_file
    config_file="$(config_path)"

    if [ -f "${config_file}" ]; then
        # shellcheck disable=SC1090  # shellcheck shouldn't lint this file
        source "${config_file}"
        return
    fi

    mkdir_private "$(config_dir)"
    write_config_template "${config_file}"

    if [ "${EDITOR:-}" = "" ]; then
        log_info "template config file generated at:"
        log_info ""
        log_info "    ${config_file}"
        log_info ""
        log_info "edit this file before continuing"
        exit 1
    fi

    "${EDITOR}" "${config_file}"
    # shellcheck disable=SC1090  # shellcheck shouldn't lint this file
    source "${config_file}"
}

write_config_template() {
    cat > "${1}" <<EOF
# shellcheck shell=bash
#
# Recommendation: All this information should be stored in a password manager. This makes your life
# much easier when it's time to restore data later.
#

RESTIC_E2EE_PASSWORD="TODO"

# Remote (S3-compatible) backup destination config
AWS_ACCESS_KEY_ID="TODO"
AWS_SECRET_ACCESS_KEY="TODO"
S3_REPOSITORY_URL="s3:https://example.com/bucket-name"

# Local (ex: USB) backup destination config
LOCAL_FILESYSTEM_UUID="Find this with the \`blkid\` command"

BACKUP_PATHS=(
    "${HOME}"
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
    '\$RECYCLE.BIN'
    "Downloads/"
    "gvfs-metadata/"
    "lost+found/"
    "node_modules/"
    "venv/"
)
EOF
}

configure_restic() {
    local backup_dest="${1}"

    case "${backup_dest}" in
        remote)
            export AWS_ACCESS_KEY_ID
            export AWS_SECRET_ACCESS_KEY
            export RESTIC_REPOSITORY="${S3_REPOSITORY_URL}"
        ;;
        local)
            RESTIC_REPOSITORY="$(get_local_repo_path "${LOCAL_FILESYSTEM_UUID}")"
            export RESTIC_REPOSITORY
        ;;
        *)
            panic "Unexpected backup destination: ${backup_dest}"
        ;;
    esac

    password_file="$(temp_file)"
    echo "${RESTIC_E2EE_PASSWORD}" > "${password_file}"
    export RESTIC_PASSWORD_FILE="${password_file}"
}
