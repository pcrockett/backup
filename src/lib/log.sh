# shellcheck shell=bash

log:info() {
    echo "${*}"
}

log:success() {
    colors:green_bold "${*}"
}

log:error() {
    colors:red_bold "${*}"
}

log:step() {
    colors:cyan "--> ${*}"
}

log:attention() {
    colors:magenta_bold "${*}"
}
