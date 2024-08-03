# shellcheck shell=bash

sudo_if_needed() {
    if [ "$(id --user)" -eq 0 ]; then
        "${@}"
    else
        echo "Running \`sudo ${*}\`..."
        sudo "${@}"
    fi
}
