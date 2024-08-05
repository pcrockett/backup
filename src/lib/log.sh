# shellcheck shell=bash

log:info() {
    echo "${*}"
}

log:success() {
    green "${*}\n"
}

log:error() {
    red "${*}\n"
}

log:step() {
    cyan "--> ${*}\n"
}

log:indent() {
    sed 's/^/    /'
}
