# shellcheck shell=bash

log:info() {
    echo "${*}"
}

log:success() {
    log:green "${*}\n"
}

log:error() {
    log:red "${*}\n"
}

log:step() {
    log:cyan "--> ${*}\n"
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

log:red() { _print_formatted "\e[31m" "${*}"; }
log:green() { _print_formatted "\e[32m" "${*}"; }
log:yellow() { _print_formatted "\e[33m" "${*}"; }
log:blue() { _print_formatted "\e[34m" "${*}"; }
log:magenta() { _print_formatted "\e[35m" "${*}"; }
log:cyan() { _print_formatted "\e[36m" "${*}"; }
log:bold() { _print_formatted "\e[1m" "${*}"; }
log:underlined() { _print_formatted "\e[4m" "${*}"; }
