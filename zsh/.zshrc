# ================================
# File Name: zshrc
# Author: cissoid
# Created At: 2019-12-27T14:03:05+0800
# Last Modified: 2019-12-30T15:12:58+0800
# ================================

# If not running interactively, don't do anything {{{
case $- in
    *i*) ;;
    *) return;;
esac
# }}}

# Lines configured by zsh-newuser-install {{{
HISTFILE=~/.histfile
HISTSIZE=65535
SAVEHIST=65535
setopt appendhistory autocd nomatch
bindkey -v
# End of lines configured by zsh-newuser-install }}}

# The following lines were added by compinstall {{{
zstyle :compinstall filename '/Users/wangxinhua/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall }}}

# global zshrc {{{
[ -r /etc/zshrc ] && source /etc/zshrc
# }}}

# env {{{
export LC_ALL=en_US.UTF-8
export LC_TYPES=en_US.UTF-8
export LANG=en_US.UTF-8

export EDITOR=vim
[[ ! "$(command -v nvim)" = "" ]] && export EDITOR=nvim

export COMPOSER_HOME=$HOME/.composer  # PHP composer
export GOPATH=$HOME/env/golang  # go
export CARGO_PATH=$HOME/.cargo/bin  # rust
export PATH=$PATH:$HOME/bin:$GOPATH/bin:$COMPOSER_HOME/vendor/bin:$CARGO_PATH

export GOPROXY=https://goproxy.cn
# }}}

# alias {{{
alias cp='cp -i'
alias du1='du --max-depth=1'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias mv='mv -i'
alias rm='rm -i'
# alias tmux='tmux -2'
alias tree1='tree -L 1'
alias vi=vim

alias goenv='GOPATH=$(pwd):$GOPATH '

[[ ! "$(command -v bat)" = "" ]] && alias cat="bat"

# alias man='LESS_TERMCAP_mb=$(printf "\e[1;31m") \
#     LESS_TERMCAP_md=$(printf "\e[1;31m")        \
#     LESS_TERMCAP_me=$(printf "\e[0m")           \
#     LESS_TERMCAP_se=$(printf "\e[0m")           \
#     LESS_TERMCAP_so=$(printf "\e[1;44;33m")     \
#     LESS_TERMCAP_ue=$(printf "\e[0m")           \
#     LESS_TERMCAP_us=$(printf "\e[1;32m")        \
#     man'

alias proxycall='all_proxy=http://127.0.0.1:1081 http_proxy=http://127.0.0.1:1081 https_proxy=http://127.0.0.1:1081'

# alias curls='curl -w"                           \n\
# Connection                                      \n\
# ----------------                                \n\
# local               %{local_ip}:%{local_port}   \n\
# remote              %{remote_ip}:%{remote_port} \n\
#                                                 \n\
# Size                                            \n\
# ----------------                                \n\
# size_request        %{size_request}             \n\
# size_download       %{size_download}            \n\
# speed_download      %{speed_download}           \n\
#                                                 \n\
# Time                                            \n\
# ----------------                                \n\
# time_namelookup     %{time_namelookup}          \n\
# time_connect        %{time_connect}             \n\
# time_appconnect     %{time_appconnect}          \n\
# time_pretransfer    %{time_pretransfer}         \n\
# time_redirect       %{time_redirect}            \n\
# time_starttransfer  %{time_starttransfer}       \n\
# time_total          %{time_total}               \n\
# " $*'

alias zsh_stats='fc -l 1 | awk '\''{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a] / count * 100 "% " a; }'\'' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n20'
alias calcavg='awk '\''{ sum+=$1; } END { print "COUNT:", NR, "AVG:", sum/NR; }'\'''
alias code_stats='wc -l **/*.* | awk '\''{ n=split($2,a,"."); counter[a[n]]+=$1; } END { for (ft in counter) print ft ":\t" counter[ft]; }'\'' | sort -nrk2'
# }}}

# oh my zsh {{{
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM="$HOME/.zsh"
ZSH_THEME="cissoid"
source $ZSH/oh-my-zsh.sh
# }}}

# antigen && plugins {{{
source /usr/local/share/antigen/antigen.zsh

# antigen use oh-my-zsh

antigen bundle themes

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply
# }}}

# local {{{
[ -r $HOME/.zshrc_local ] && source $HOME/.zshrc_local
# }}}

# vim: foldmethod=marker foldlevel=0
