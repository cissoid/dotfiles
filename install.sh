#!/bin/bash

if [ ! `which stow` ]; then
    echo Ready to install stow...

    if [ "$(uname)" == "Darwin" ]; then
        brew install stow
    fi
fi

stow bash
stow git
stow tmux
stow vim

stow formatters
stow linters
