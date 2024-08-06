# shellcheck shell=bash

panic() {
    # for when you really shouldn't keep calm and carry on
    log:red "FATAL: ${*}\n" >&2
    exit 1
}

add_trap() {
    # [tag:add_trap]
    TRAPS=("${*}" "${TRAPS[@]}")
}
