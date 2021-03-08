# exit code
PROMPT='%{$FX[bold]$FG[015]$BG[160]%}%(?..[%?])%{$FX[reset]%}'
# pyvenv
PROMPT+='$(function {
    [[ -n "${VIRTUAL_ENV}" ]] && echo "($(basename ${VIRTUAL_ENV}))"
})'
# username and pwd
PROMPT+='['
# PROMPT+='%{$FG[%(!.196.002)]%}%n@%M%{$FX[reset]%}'
PROMPT+='$(function {
    if [[ "%n" == "root" ]]; then
        local _fg=196
    else
        local _fg=002
    fi
    echo "%{$FG[$_fg]%}%n@%M%{$FX[reset]%}"
})'
PROMPT+=':'
PROMPT+='%{$FG[012]%}%(5~|%-1~/.../%3~|%4~)%{$FX[reset]%}'
PROMPT+=']'
PROMPT+='$(function {
    local git_path=$(which git 2>/dev/null)
    local inside_repo=$(git rev-parse --is-inside-work-tree 2>/dev/null)
    if [[ -n "${git_path}" ]] && [[ "${inside_repo}" == "true" ]]; then
        local branch=$(git branch | grep -Po "(?<=\\* \\(HEAD detached at )[^\\s]+(?=\\)$)|(?<=\\* )[^\\s]+(?=$)")
        local changed=$(git status -s -uno);
        if [[ -n "${changed}" ]]; then
            local _fg=220
        else
            local _fg=015
        fi
        echo "(%{$FG[$_fg]%}${branch}%{$FX[reset]%})"
    fi
})'
PROMPT+=$'\n'
# zsh-vi-mode
PROMPT+='$(function {
    case ${ZVM_MODE} in
        $ZVM_MODE_INSERT)
            echo "%{$FG[012]%}+%{$FX[reset]%}"
        ;;
        $ZVM_MODE_NORMAL)
            echo "%{$FG[196]%}:%{$FX[reset]%}"
        ;;
        $ZVM_MODE_VISUAL)
            echo "%{$FG[196]%}v%{$FX[reset]%}"
        ;;
        $ZVM_MODE_VISUAL_LINE)
            echo "%{$FG[196]%}l%{$FX[reset]%}"
        ;;
    esac
})'
PROMPT+='%(!.#.$) '
# vim: filetype=zsh
