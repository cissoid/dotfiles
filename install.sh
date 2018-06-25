#!/usr/bin/env bash

function get_platform() {
    if [ "$(uname)" == "Darwin" ]; then
        echo "macOS"
    else
        lsb_release -i | awk '{print $3}'
    fi
}

function link() {
    # for name in $(ls -A "${1}"); do
    #     ln -sf "${1}/${name}" "${2}"
    # done
	stow -t "${2}" "${1}"
}

declare -A stow_map

function init() {
    stow_map["bash"]="${HOME}"
    stow_map["git"]="${HOME}"
    stow_map["tmux"]="${HOME}"
    stow_map["vim"]="${HOME}"
    stow_map["ctags"]="${HOME}"

    # formaters
    stow_map["autopep8"]="${HOME}"
    stow_map["js-beautify"]="${HOME}"

    # linters

    local platform
    platform="$(get_platform)"
    case "${platform}" in
        "macOS")
            stow_map["vscode"]="${HOME}/Library/Application Support/Code/User"
            ;;
        "Arch")
            stow_map["i3"]="${HOME}"
            ;;
    esac
}

function install() {
    for src in "${!stow_map[@]}"; do
        dest="${stow_map[${src}]}"
        link "${src}" "${dest}"
    done
}

init && install
