# shellcheck shell=bash
## [tag:before-hook]
##
## Any code here will be placed inside a `before_hook()` function and called
## before running any command (but after processing its arguments).

BACKUP_TEMP_DIR="$(mktemp --directory backup.XXXXXX)"
EXIT_HOOKS=()

on_exit() {
    rm -rf "${BACKUP_TEMP_DIR}"
    for hook in "${EXIT_HOOKS[@]}"; do
        eval "${hook}"
    done
}
trap 'on_exit' SIGINT SIGTERM EXIT
