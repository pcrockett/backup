# shellcheck shell=bash
# shellcheck disable=SC2154

config:read

path_to_check="${args[--file]:-}"
check_failures=()

if [ "${path_to_check}" != "" ]; then
    test -f "${path_to_check}" || panic "${path_to_check} doesn't exist"
    path_to_check="$(readlink --canonicalize-existing "${path_to_check}")"
    original_hash="$(util:sha256sum "${path_to_check}")"
    log:info "Original file hash: ${original_hash}"
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

check_local() {
    local:mount_device_by_uuid "${LOCAL_FILESYSTEM_UUID}"
    local:unmount_on_exit "${LOCAL_FILESYSTEM_UUID}"
    configure_and_run local
}

check_remote() {
    configure_and_run remote
}

case "${args[destination]:-}" in
    local)
        check_local
    ;;
    remote)
        check_remote
    ;;
    *)
        # no destination specified; run both.
        log:step "Checking local..."
        check_local
        log:step "Checking remote..."
        check_remote
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
