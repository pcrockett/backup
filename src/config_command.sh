# shellcheck shell=bash

config_file="$(config_path)"

if [ ! -f "${config_file}" ]; then
    mkdir_private "$(config_dir)"
    write_config_template "${config_file}"
fi

display_config() {
    if [ "${args[--no-pager]:-}" != "" ]; then
        cat "${config_file}"
        return
    fi

    if command -v bat &> /dev/null; then
        bat --language bash "${config_file}"
    elif command -v less &> /dev/null; then
        less "${config_file}"
    else
        cat "${config_file}"
    fi
}

edit_config() {
    if [ "${EDITOR:-}" == "" ]; then
        panic "\$EDITOR has not been set!"
    else
        "${EDITOR}" "${config_file}"
    fi
}

if [ "${args[--edit]:-}" == "" ]; then
    display_config
else
    edit_config
fi
