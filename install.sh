#!/bin/bash

if [ ! `which stow` ]; then
    echo Ready to install stow...

    if [ "$(uname)" == "Darwin" ]; then
        brew install stow
    elif [ "$(lsb_release -i | awk '{print $3}')" == "Ubuntu" ]; then
        sudo apt install stow
    else
        echo Unknown platform.
        exit -1
    fi
fi

stow bash
stow git
stow tmux
stow vim

stow formatters
stow linters
