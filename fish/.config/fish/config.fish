if status is-interactive
    # vi mode
    function fish_user_key_bindings

        fish_vi_key_bindings
        bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
        bind -M insert \cf accept-autosuggestion
    end
    set fish_cursor_insert line

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
    alias proxycall="http_proxy=http://127.0.0.1:1081 https_proxy=http://127.0.0.1:1081 all_proxy=http://127.0.0.1:1081"

    # starship prompt
    starship init fish | source

    # asdf hook
    source /usr/local/opt/asdf/libexec/asdf.fish
end

