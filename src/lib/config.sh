# shellcheck shell=bash

config:directory_path() {
    echo "/etc/backup"
}

config:file_path() {
    echo "$(config:directory_path)/config.sh"
}

config:read() {
    local config_file
    config_file="$(config:file_path)"

    if [ -f "${config_file}" ]; then
        # shellcheck disable=SC1090  # shellcheck shouldn't lint this file
        source "${config_file}"
        return
    fi

    util:mkdir_private "$(config:directory_path)"
    config:write_template_to "${config_file}"

    if [ "${EDITOR:-}" = "" ]; then
        log:info "template config file generated at:"
        log:info ""
        log:info "    ${config_file}"
        log:info ""
        log:info "edit this file before continuing"
        exit 1
    fi

    "${EDITOR}" "${config_file}"
    # shellcheck disable=SC1090  # shellcheck shouldn't lint this file
    source "${config_file}"
}

config:write_template_to() {
    cat > "${1}" <<EOF
# shellcheck shell=bash
#
# Recommendation: All this information should be stored in a password manager. This makes your life
# much easier when it's time to restore data later.
#

RESTIC_E2EE_PASSWORD="TODO"

# Offsite (S3-compatible) backup destination config
AWS_ACCESS_KEY_ID="TODO"
AWS_SECRET_ACCESS_KEY="TODO"
S3_REPOSITORY_URL="s3:https://example.com/bucket-name"

# External (ex: USB drive) backup destination config
EXTERNAL_FILESYSTEM_UUID="Find this with the \`blkid\` command"
EXTERNAL_BACKUP_DIR="restic-backup"  # save on the external filesystem under restic-backup/ directory

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

config:setup_restic_env() {
    local backup_dest="${1}"

    case "${backup_dest}" in
        "${OFFSITE_BACKUP_DEST}")
            export AWS_ACCESS_KEY_ID
            export AWS_SECRET_ACCESS_KEY
            export RESTIC_REPOSITORY="${S3_REPOSITORY_URL}"
        ;;
        "${EXTERNAL_BACKUP_DEST}")
            RESTIC_REPOSITORY="$(external:repo_path_by_uuid "${EXTERNAL_FILESYSTEM_UUID}" "${EXTERNAL_BACKUP_DIR}")"
            export RESTIC_REPOSITORY
        ;;
        *)
            panic "Unexpected backup destination: ${backup_dest}"
        ;;
    esac

    password_file="$(util:temp_file)"
    echo "${RESTIC_E2EE_PASSWORD}" > "${password_file}"
    export RESTIC_PASSWORD_FILE="${password_file}"
}
