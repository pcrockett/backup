# shellcheck shell=bash

lines() {
    # iterate through args, and output each one on a new line.
    #
    # example usage:
    #
    #     lines a b c
    #
    # outputs:
    #
    #     a
    #     b
    #     c
    #
    for i in "${@}"; do
        echo "${i}"
    done
}
