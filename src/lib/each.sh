# shellcheck shell=bash

each() {
    # iterate through stdin lines, and execute a command for each line.
    # the stdin line will be passed to the command as the last parameter.
    #
    # example usage:
    #
    #     printf 'foo\nbar' | each echo "you said: "
    #
    # outputs:
    #
    #     you said: foo
    #     you said: bar
    #
    while IFS= read -r line || [ -n "${line}" ]
    do
        "${@}" "${line}"
    done < <(cat)
}
