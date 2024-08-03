# shellcheck shell=bash

mkdir_private() {
    (
        umask u=rwx,g=,o=
        mkdir --parent "${1}"
    )
}
