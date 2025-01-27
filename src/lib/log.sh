# shellcheck shell=bash

log:info() {
    echo "${*}"
}

log:success() {
    colors:green_bold "${*}\n"
}

log:error() {
    colors:red_bold "${*}\n"
}

log:step() {
    colors:cyan "--> ${*}\n"
}

log:attention() {
    colors:magenta_bold "${*}\n"
}
