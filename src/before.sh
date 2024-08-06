# shellcheck shell=bash
## [tag:before-hook]
##
## Any code here will be placed inside a `before_hook()` function and called
## before running any command (but after processing its arguments).

XDG_STATE_HOME="${XDG_STATE_HOME:-"${HOME}/.local/state"}"
BACKUP_TEMP_DIR="$(mktemp --directory "${TMPDIR:-/tmp}/backup.XXXXXX")"
chmod -R go-rwx "${BACKUP_TEMP_DIR}"

EXTERNAL_BACKUP_DEST="external"
OFFSITE_BACKUP_DEST="offsite"

on_exit() {
    rm -rf "${BACKUP_TEMP_DIR}"
}
trap 'on_exit' SIGINT SIGTERM EXIT
