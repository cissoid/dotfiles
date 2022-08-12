if status is-interactive
    # vi + emacs hybrid mode
    function fish_user_key_bindings
        for mode in default insert visual
            fish_default_key_bindings -M $mode
        end
        fish_vi_key_bindings --no-erase
        bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
    end

    # environment variables
    set -Ux LC_ALL en_US.UTF-8
    set -Ux LC_TYPES en_US.UTF-8
    set -Ux LANG en_US.UTF-8

    # aliases
    if type -q exa
        alias ls="exa --group"
    end
    alias ll="ls -l"
    alias cp="cp -i"
    alias mv="mv -i"
    alias rm="rm -i"
    if type -q trash
        alias rm="trash -i"
    end
    if type -q bat
        alias cat="bat"
        set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"
    end

    alias proxycall="http_proxy=http://127.0.0.1:1081 https_proxy=http://127.0.0.1:1081 all_proxy=http://127.0.0.1:1081"

    # starship prompt
    if type -q starship
        starship init fish | source
    end

    # asdf hook
    if type -q brew; and set -l asdf "$(brew --prefix)/opt/asdf/libexec/asdf.fish"; and test -e $asdf
        source $asdf
    end

    # fzf configuration
    if type -q fzf_configure_bindings
        fzf_configure_bindings --directory=\cf --git_log=\\g --processes=\\p
    end
end
