# shellcheck shell=bash

panic() {
    # for when you really shouldn't keep calm and carry on
    log:red "FATAL: ${*}\n" >&2
    exit 1
}
