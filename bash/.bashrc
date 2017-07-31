#!/bin/bash
# ================================
# File Name: bashrc
# Author: cissoid
# Created At: 2015-09-01T09:34:00+0800
# Last Modified: 2017-07-31T18:30:22+0800
# ================================

# source global definitions. {{{
if [ -r /etc/bashrc ]; then
	. /etc/bashrc
elif [ -r /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi
# }}}

# shopt -s cdspell
shopt -s dirspell
shopt -s cmdhist
# support for **
shopt -s globstar

# environment variables. {{{

export LC_ALL=en_US.UTF-8
export LC_TYPES=en_US.UTF-8
export LANG=en_US.UTF-8
export TERM=xterm-256color
export PROMPT_DIRTRIM=3
export HISTSIZE=65535
export HISTFILESIZE=65535

# PS1 settings. {{{
# non-printable characters should be surrounded by \[\].
# use tput instead of raw ascii escape character.
# see http://stackoverflow.com/questions/5087036/bashrc-break-second-line-entered-in-shell-eats-up-first-line
# exit_status
PS1='$(
    exit_code=$?;
    if [ $exit_code -ne 0 ]; then
        bold="\[$(tput bold)\]";
        foreground="\[$(tput setaf 15)\]";
        background="\[$(tput setab 160)\]";
        reset="\[$(tput sgr0)\]";
        printf %s $bold $foreground $background "[" $exit_code "]" $reset;
    fi
)'
# python virtualenv
PS1+='$(
    if [ ! "$VIRTUAL_ENV" == "" ]; then
        venv=`basename $VIRTUAL_ENV`;
        printf %s "(" $venv ")";
    fi
)'
# user, host and directory
PS1+="["
PS1+='$(
    if [ "\u" == "root" ]; then
        foreground="\[$(tput setaf 196)\]";
    else
        foreground="\[$(tput setaf 2)\]";
    fi
    reset="\[$(tput sgr0)\]";
    printf %s $foreground "\u@\h" $reset;
)'
PS1+=":"
PS1+='$(
    bold="\[$(tput bold)\]";
    foreground="\[$(tput setaf 12)\]";
    reset="\[$(tput sgr0)\]";
    printf %s $bold $foreground "\w" $reset;
)'
PS1+="]"
# git branch
PS1+='$(
    git_path=`which git 2>/dev/null`;
    inside_repo=`git rev-parse --is-inside-work-tree 2>/dev/null`;
    if [ ! "$git_path" == "" ] && [ "$inside_repo" == "true" ]; then
        branch=`git branch | grep -Po "(?<=\\* \\(HEAD detached at )[^\\s]+(?=\\)$)|(?<=\\* )[^\\s]+(?=$)"`;
        changed=`git status -s -uno`;
        if [ "$changed" == "" ]; then
            foreground="\[$(tput setaf 15)\]";
        else
            foreground="\[$(tput setaf 220)\]";
        fi
        reset="\[$(tput sgr0)\]";
        printf %s "(" $foreground $branch $reset ")";
    fi
)'
PS1+="\\$ "
export PS1
# }}}

# powerline settings. {{{
# export POWERLINE_BASH_CONTINUATION=1
# export POWERLINE_BASH_SELECT=1
# export POWERLINE_INSTALL_PATH
# POWERLINE_INSTALL_PATH=$(pip show powerline-status | grep Location | awk '{print $2}')/powerline
# }}}

export COMPOSER_HOME=$HOME/.composer
# export GOROOT=~/go
export GOPATH=$HOME/env/golang
export CARGO_PATH=$HOME/.cargo/bin

export PATH=$PATH:$HOME/bin:$GOPATH/bin:$COMPOSER_HOME/vendor/bin:$CARGO_PATH
# }}}


if [ "$(uname)" == "Linux" ]; then
    # Linux specific config. {{{
    if ! shopt -oq posix; then
      if [ -r /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      elif [ -r /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
    fi
    
    # if [ -f "$(which powerline-daemon)" ]; then
    #     flock -xn /tmp/powerline-daemon.lock powerline-daemon -q
    #     . "${POWERLINE_INSTALL_PATH}/bindings/bash/powerline.sh"
    # fi
    # }}}

elif [ "$(uname)" == "Darwin" ]; then
    # OS X specific config. {{{
    # HOMEBREW_PREFIX=$(brew --prefix)
    HOMEBREW_PREFIX="/usr/local"
    export PATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$HOMEBREW_PREFIX/Cellar/gettext/0.19.8.1/bin:$PATH
    export MANPATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman:$HOMEBREW_PREFIX/Cellar/gettext/share/man:$MANPATH

    if [ -r "$HOMEBREW_PREFIX/etc/bash_completion" ]; then
        . "$HOMEBREW_PREFIX/etc/bash_completion"
    fi

    # if [ -r "$(which powerline-daemon)" ]; then
    #     . "${POWERLINE_INSTALL_PATH}/bindings/bash/powerline.sh"
    # fi
    # }}}
fi

# aliases. {{{
alias ..='cd ..'
alias cp='cp -i'
alias du1='du --max-depth=1'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias mv='mv -i'
alias rm='rm -i'
alias s='ssh'
# alias tmux='tmux -2'
alias tree1='tree -L 1'
alias vi=vim
alias goenv='GOPATH=$(pwd):$GOPATH '

alias man='LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m")        \
    LESS_TERMCAP_me=$(printf "\e[0m")           \
    LESS_TERMCAP_se=$(printf "\e[0m")           \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m")     \
    LESS_TERMCAP_ue=$(printf "\e[0m")           \
    LESS_TERMCAP_us=$(printf "\e[1;32m")        \
    man'

alias proxycall='http_proxy=http://127.0.0.1:1081 https_proxy=$http_proxy'

alias curls='curl -i -w"                        \n\
Connection                                      \n\
----------------                                \n\
local               %{local_ip}:%{local_port}   \n\
remote              %{remote_ip}:%{remote_port} \n\
                                                \n\
Size                                            \n\
----------------                                \n\
size_request        %{size_request}             \n\
size_download       %{size_download}            \n\
speed_download      %{speed_download}           \n\
                                                \n\
Time                                            \n\
----------------                                \n\
time_namelookup     %{time_namelookup}          \n\
time_connect        %{time_connect}             \n\
time_appconnect     %{time_appconnect}          \n\
time_pretransfer    %{time_pretransfer}         \n\
time_redirect       %{time_redirect}            \n\
time_starttransfer  %{time_starttransfer}       \n\
time_total          %{time_total}               \n\
" $*'

alias bash_stats='fc -l 1 | awk '\''{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a] / count * 100 "% " a; }'\'' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n20'
alias calcavg='awk '\''{ sum+=$1; } END { print "COUNT:", NR, "AVG:", sum/NR; }'\'''
alias code_stats='wc -l **/*.* | awk '\''{ n=split($2,a,"."); counter[a[n]]+=$1; } END { for (ft in counter) print ft ":\t" counter[ft]; }'\'' | sort -nrk2'
# }}}

function pip-upgrade-all() {
    exclude_regex="^(0)"
    for package in $*; do
        exclude_regex+="|($package)"
    done
    exclude_regex+="$"
    pip freeze | grep -Po "[^=]+?(?==)" | grep -iPv "$exclude_regex" | xargs pip install -U
}

function backup() {
    tar -zcvf $1_`date +"%Y%m%d%H%M%S"`.tar.gz $1
}

function auto_init() {
    autoscan
    mv configure.{scan,ac}
    vim $_
    aclocal
    autoconf
    vim Makefile.am
    automake --add-missing
}

# vim: foldmethod=marker foldlevel=0
