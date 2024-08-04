# shellcheck shell=bash

# I'm calling this my "standard library" -- no namespaces required for these functions

panic() {
    # for when you really shouldn't keep calm and carry on
    red "FATAL: ${*}\n" >&2
    exit 1
}

not_implemented() {
    panic "Not implemented yet."
}

_output_is_tty() { [[ -t 1 ]]; }

_print_formatted() {
    local format="${1}"
    shift
    if _output_is_tty; then
        printf "%b%b\e[0m" "${format}" "${*}"
    else
        printf "%b" "${*}"
    fi
}

red() { _print_formatted "\e[31m" "${*}"; }
green() { _print_formatted "\e[32m" "${*}"; }
yellow() { _print_formatted "\e[33m" "${*}"; }
blue() { _print_formatted "\e[34m" "${*}"; }
magenta() { _print_formatted "\e[35m" "${*}"; }
cyan() { _print_formatted "\e[36m" "${*}"; }
bold() { _print_formatted "\e[1m" "${*}"; }
underlined() { _print_formatted "\e[4m" "${*}"; }
