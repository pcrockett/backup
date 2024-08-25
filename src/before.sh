# shellcheck shell=bash
# shellcheck disable=SC2034
## [tag:before-hook]
##
## Any code here will be placed inside a `before_hook()` function and called
## before running any command (but after processing its arguments).

if [ "$(id --user)" -ne 0 ]; then
    panic "This command must be run as root."
fi

readonly RUN_STATE_DIR="/run/backup"
BACKUP_TEMP_DIR="$(mktemp --directory "${TMPDIR:-/tmp}/backup.XXXXXX")"
readonly BACKUP_TEMP_DIR
chmod -R go-rwx "${BACKUP_TEMP_DIR}"

readonly EXTERNAL_BACKUP_DEST="external"
readonly OFFSITE_BACKUP_DEST="offsite"

# don't modify this yourself. instead use [ref:add_trap].
TRAPS=(
    "rm -rf $(util:escape_value "${BACKUP_TEMP_DIR}")"
)

on_exit() {
    for trap in "${TRAPS[@]}"; do
        # log:info "Running \`${trap}\`..."
        eval "${trap}"
    done
}
trap 'on_exit' SIGINT SIGTERM EXIT
