PROMPT='$(exit_code)$(pyvenv)[$(who):$(pwd)]$(git_prompt_info) '
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}"
# vim: filetype=zsh
