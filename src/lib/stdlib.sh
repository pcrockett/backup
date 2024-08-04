# shellcheck shell=bash

# I'm calling this my "standard library" -- no namespaces required for these functions

panic() {
    # for when you really shouldn't keep calm and carry on
    echo "FATAL: ${*}" >&2
    exit 1
}

not_implemented() {
    panic "Not implemented yet."
}
