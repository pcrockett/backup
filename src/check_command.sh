# shellcheck shell=bash
# shellcheck disable=SC2154

config:read

path_to_check="${args[--file]:-}"
check_failures=()

if [ "${path_to_check}" != "" ]; then
    test -f "${path_to_check}" || panic "${path_to_check} doesn't exist"
    path_to_check="$(readlink --canonicalize-existing "${path_to_check}")"
    original_hash="$(util:sha256sum "${path_to_check}")"
    log:magenta "Original file hash: ${original_hash}\n"
fi

configure_and_run() {
    local dest="${1}"
    config:setup_restic_env "${dest}"

    if [ "${path_to_check}" == "" ]; then
        if ! restic --verbose check --read-data-subset 100M; then
            check_failures+=("${dest} backup destination encountered an error.")
        fi
    else
        hash:get_file_hash "${dest}" "${path_to_check}"
        if [ "${original_hash}" == "${FILE_HASH}" ]; then
            log:success "${dest} OK: ${FILE_HASH}"
        else
            log:error "${dest} FAIL: ${FILE_HASH}"
            check_failures+=("${dest} file hash does not match original.")
        fi
    fi
}

check_external() {
    external:mount_device_by_uuid "${EXTERNAL_FILESYSTEM_UUID}"
    external:unmount_on_exit "${EXTERNAL_FILESYSTEM_UUID}"
    configure_and_run "${EXTERNAL_BACKUP_DEST}"
}

check_offsite() {
    configure_and_run "${OFFSITE_BACKUP_DEST}"
}

case "${args[destination]:-}" in
    "${EXTERNAL_BACKUP_DEST}")
        check_external
    ;;
    "${OFFSITE_BACKUP_DEST}")
        check_offsite
    ;;
    *)
        # no destination specified; run both.
        log:step "Checking ${EXTERNAL_BACKUP_DEST}..."
        check_external
        log:step "Checking ${OFFSITE_BACKUP_DEST}..."
        check_offsite
    ;;
esac

if [ "${#check_failures[@]}" -gt 0 ]; then
    for failure in "${check_failures[@]}"; do
        log:error "${failure}"
    done
    exit 1
else
    log:success "OK: No errors encountered."
fi
