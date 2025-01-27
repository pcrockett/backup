# shellcheck shell=bash

panic() {
    # for when you really shouldn't keep calm and carry on
    log:error "FATAL: ${*}" >&2
    exit 1
}

add_trap() {
    # [tag:add_trap]
    TRAPS=("${*}" "${TRAPS[@]}")
}
