function exit_code() {
    local code=$?;
    if [ $code -ne 0 ]; then
        local bold="$(tput bold)";
        local foreground="$(tput setaf 15)";
        local background="$(tput setab 160)";
        local reset="$(tput sgr0)";
        # echo "$bold$foreground$background[$code]$reset"
        printf %s $bold $foreground $background "[" $code "]" $reset;
    fi
}

function pyvenv() {
        # pyenv_path=$(which pyenv 2>/dev/null);
        # if [ ! "$pyenv_path" == "" ]; then
        #     printf %s "(" $(pyenv version | grep -Po "(?<=^)[^\\s]+") ")";
        if [[ ! "$VIRTUAL_ENV" == "" ]]; then
            printf %s "(" $(basename $VIRTUAL_ENV) ")";
        fi
}

function who() {
    # echo "%n"
    if [[ "%n" == "root" ]]; then
        foreground="\[$(tput setaf 196)\]";
    else
        foreground="\[$(tput setaf 2)\]";
    fi
    reset="\[$(tput sgr0)\]";
    printf %s $foreground "%n@%M" $reset;
}

function pwd() {
    echo "%d"
}

function git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}
