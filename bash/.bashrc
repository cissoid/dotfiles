#!/bin/bash
# ================================
# File Name: bashrc
# Author: cissoid
# Created At: 2015-09-01T09:34:00+0800
# Last Modified: 2018-06-04T17:56:11+0800
# ================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

function __ts() {
    if [ -x /usr/local/bin/gdate ]; then  # macOS
        echo $(/usr/local/bin/gdate +%s.%N)
    else
        echo $(date +%s.%N)
    fi
}

function __timeit() {
    # Args: level, label, func, args
    __level=$1
    __label=$2
    __func=$3
    shift 3

    for (( i=0; i<$__level; i++ )); do
        echo -n '-'
    done
    echo -n '> '
    echo -n "$__label..."
    if [[ $__level == 1 ]]; then
        echo ""
    fi

    __start_time=$(__ts)
    eval $__func $*
    __end_time=$(__ts)
    printf "%.6fs\n" $(echo "$__end_time-$__start_time" | bc)

    unset __level
    unset __label
    unset __func
    unset __start_time
    unset __end_time
}

function __load_global_bashrc() {
    if [ -r /etc/bashrc ]; then
        source /etc/bashrc
    elif [ -r /etc/bash.bashrc ]; then
        source /etc/bash.bashrc
    fi
}

function __set_custom_shopt() {
    # shopt -s cdspell
    shopt -s dirspell
    shopt -s cmdhist
    shopt -s globstar  # support for **
}

function __set_environment_variables() {
    export LC_ALL=en_US.UTF-8
    export LC_TYPES=en_US.UTF-8
    export LANG=en_US.UTF-8
    export TERM=xterm-256color
    export PROMPT_DIRTRIM=3  # strip when pwd too long.
    export HISTSIZE=65535
    export HISTFILESIZE=65535
}

function __set_ps1() {
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
        pyenv_path=$(which pyenv 2>/dev/null);
        if [ ! "$pyenv_path" == "" ]; then
            printf %s "(" $(pyenv version | grep -Po "(?<=^)[^\\s]+") ")";
        elif [ ! "$VIRTUAL_ENV" == "" ]; then
            printf %s "(" $(basename $VIRTUAL_ENV) ")";
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
        git_path=$(which git 2>/dev/null);
        inside_repo=$(git rev-parse --is-inside-work-tree 2>/dev/null);
        if [ ! "$git_path" == "" ] && [ "$inside_repo" == "true" ]; then
            branch=$(git branch | grep -Po "(?<=\\* \\(HEAD detached at )[^\\s]+(?=\\)$)|(?<=\\* )[^\\s]+(?=$)");
            changed=$(git status -s -uno);
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
}

function __set_path() {
    export COMPOSER_HOME=$HOME/.composer  # PHP composer
    export GOPATH=$HOME/env/golang  # go
    export CARGO_PATH=$HOME/.cargo/bin  # rust
    export PATH=$PATH:$HOME/bin:$GOPATH/bin:$COMPOSER_HOME/vendor/bin:$CARGO_PATH
}

function __set_bash_completion() {
    if [ "$(uname)" == "Linux" ]; then
        # Linux specific config.
        if ! shopt -oq posix; then
          if [ -r /usr/share/bash-completion/bash_completion ]; then
            source /usr/share/bash-completion/bash_completion
          elif [ -r /etc/bash_completion ]; then
            source /etc/bash_completion
          fi
        fi
    elif [ "$(uname)" == "Darwin" ]; then
        # OS X specific config.
        HOMEBREW_PREFIX=$(brew --prefix)
        export PATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH
        export MANPATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman:$MANPATH

        if [ -r "$HOMEBREW_PREFIX/etc/bash_completion" ]; then
            source "$HOMEBREW_PREFIX/etc/bash_completion"
        fi
    fi
}

function __set_alias() {
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
}

function __set_alias_ex() {
    alias goenv='GOPATH=$(pwd):$GOPATH '

    alias man='LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m")        \
        LESS_TERMCAP_me=$(printf "\e[0m")           \
        LESS_TERMCAP_se=$(printf "\e[0m")           \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m")     \
        LESS_TERMCAP_ue=$(printf "\e[0m")           \
        LESS_TERMCAP_us=$(printf "\e[1;32m")        \
        man'

    alias proxycall='all_proxy=http://127.0.0.1:1081'

    alias curls='curl -w"                           \n\
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
}

function __load_local_bashrc() {
    if [ -f ~/.bashrc_local ]; then
        source ~/.bashrc_local
    fi
}

function __init() {
    __st=$(__ts)
    __timeit 3 "loading global bashrc" __load_global_bashrc
    __timeit 3 "set shopt" __set_custom_shopt
    __timeit 3 "set environment variables" __set_environment_variables
    __timeit 3 "set PS1" __set_ps1
    __timeit 3 "set PATH" __set_path
    __timeit 3 "loading bash completion" __set_bash_completion
    __timeit 3 "set alias" __set_alias
    __timeit 3 "set alias ex" __set_alias_ex
    __timeit 3 "loading local bashrc" __load_local_bashrc
    __et=$(__ts)
    printf " --> total %.6fs\n" $(echo "$__et-$__st" | bc)
    unset __st
    unset __et
}

function __uninit() {
    unset __ts
    unset __timeit
    unset __load_global_bashrc
    unset __set_custom_shopt
    unset __set_environment_variables
    unset __set_ps1
    unset __set_path
    unset __set_bash_completion
    unset __set_alias
    unset __set_alias_ex
    unset __load_local_bashrc
    unset __init
    unset __uninit
}

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

__init
__uninit
