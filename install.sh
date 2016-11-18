#!/usr/bin/env bash

function get_platform() {
    if [ "$(uname)" == "Darwin" ]; then
        echo "macOS"
    else
        echo "$(lsb_release -i | awk '{print $3}')"
    fi
}

function install_stow() {
    if [ ! `which stow` ]; then
        echo "Ready to install stow..."

        local platform=$(get_platform)

        if [ "$platform" == "macOS" ]; then
            brew install stow
        elif [ "$platform" == "Ubuntu" ]; then
            sudo apt install stow
        else
            echo "Unknown platform."
            exit 1
        fi
    fi
}

function install() {
    install_stow

    stow bash
    stow git
    stow tmux
    stow vim

    local platform=$(get_platform)
    if [ "$platform" == "macOS" ]; then
        stow -t "$HOME/Library/Application Support/Code/User" vscode
    fi

    stow formatters
    stow linters
}

function install_linter() {
    local install_maps=(
        "pip;flake8;flake8"
    )
    install_maps+=(
        "npm;eslint;eslint"
    )

    for map in ${install_maps[@]}
    do
        echo $map
    done
}

function usage() {
    echo "Usage: $0 [linter|formatter]"
}


case "$1" in 
    "")
        install $*
        ;;
    "linter")
        install_linter $*
        ;;
    "formatter")
        install_formatter $*
        ;;
    *)
        usage $*
esac
