# shellcheck shell=bash

temp_file() {
    # create a temp file in ${BACKUP_TEMP_DIR} and echo its file path to stdout
    # ${BACKUP_TEMP_DIR} will be deleted in [ref:before-hook]
    mktemp --tmpdir="${BACKUP_TEMP_DIR}"
}
