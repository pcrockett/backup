# shellcheck shell=bash

log:info() {
    echo "${*}"
}

log:step() {
    cyan "--> ${*}\n"
}

log:indent() {
    sed 's/^/    /'
}
