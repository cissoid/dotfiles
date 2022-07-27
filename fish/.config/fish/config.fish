if status is-interactive
    # vi + emacs hybrid mode
    function fish_user_key_bindings
        for mode in default insert visual
            fish_default_key_bindings -M $mode
        end
        fish_vi_key_bindings --no-erase
        bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
    end

    set -Ux LC_ALL en_US.UTF-8
    set -Ux LC_TYPES en_US.UTF-8
    set -Ux LANG en_US.UTF-8

    if type -q exa
        alias ls="exa --group"
    end
    alias ll="ls -l"
    alias cp="cp -i"
    alias mv="mv -i"
    alias rm="rm -i"
    if type -q bat
        alias cat="bat"
    end
    alias man='LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m")        \
        LESS_TERMCAP_me=$(printf "\e[0m")           \
        LESS_TERMCAP_se=$(printf "\e[0m")           \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m")     \
        LESS_TERMCAP_ue=$(printf "\e[0m")           \
        LESS_TERMCAP_us=$(printf "\e[1;32m")        \
        /usr/bin/env man'

    alias proxycall="http_proxy=http://127.0.0.1:1081 https_proxy=http://127.0.0.1:1081 all_proxy=http://127.0.0.1:1081"

    # starship prompt
    starship init fish | source

    # asdf hook
    source /usr/local/opt/asdf/libexec/asdf.fish

    # fzf configuration
    if type -q fzf_configure_bindings
        fzf_configure_bindings --directory=\cf --git_log=\\g --processes=\\p
    end
end
