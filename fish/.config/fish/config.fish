if status is-interactive
    # vi + emacs hybrid mode
    function fish_user_key_bindings
        fish_hybrid_key_bindings
        bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
    end

    # add homebrew bin
    begin
        set -l system "$(uname -s)"
        set -l arch "$(uname -m)"
        if test "$system" = "Darwin"
            if test "$arch" = "arm64"
                fish_add_path --prepend /opt/homebrew/bin
            end
        else if test "$system" = "Linux"
            fish_add_path --prepend /home/linuxbrew/.linuxbrew/bin
        end
    end
    if test -e "$(brew --prefix)/opt/coreutils/libexec/gnubin"
        fish_add_path --prepend "$(brew --prefix)/opt/coreutils/libexec/gnubin"
    end
    fish_add_path --prepend $HOME/.local/bin

    # environment variables
    set -gx LC_ALL en_US.UTF-8
    set -gx LC_TYPES en_US.UTF-8
    set -gx LANG en_US.UTF-8
    if type -q nvim
        set -gx EDITOR nvim
    end

    # aliases

    # grc aliases
    if type -q brew && test -e "$(brew --prefix)/etc/grc.fish"
        source "$(brew --prefix)/etc/grc.fish"
    end

    if type -q eza
        alias ls="eza --group"
    end
    alias ll="ls -l"
    alias cp="cp -i"
    alias mv="mv -i"
    alias rm="rm -i"
    if type -q trash
        alias rm="trash -i"
    end
    if type -q bat
        set -gx BAT_THEME "Monokai Extended"
        alias cat="bat"
        set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    end

    alias proxycall="http_proxy=http://127.0.0.1:1081 https_proxy=http://127.0.0.1:1081 all_proxy=http://127.0.0.1:1081"

    # starship prompt
    if type -q starship
        starship init fish | source
    end

    # direnv
    if type -q direnv
        direnv hook fish | source
    end

    # asdf hook
    if not set -q ASDF_DIR && type -q brew && set -l asdf "$(brew --prefix)/opt/asdf/libexec/asdf.fish" && test -e $asdf
        source $asdf
    end

    # fzf configuration
    if type -q fzf_configure_bindings
        fzf_configure_bindings --directory=\cf --git_log=\\g --processes=\\p
    end

    # zoxide
    if type -q zoxide
        zoxide init fish | source
    end

    if type -q pdm
        function pdm --inherit-variable pdm --wraps pdm
            if isatty 1 && test "$(count $argv)" -eq 1 && test "$argv[1]" = "shell"
                fish -C "eval $(pdm venv activate)"
            else
                eval command pdm $argv
            end
        end
    end

    # neovide environment
    # if type -q neovide
        # set -gx NEOVIDE_FRAME buttonless
        # set -gx NEOVIDE_MULTIGRID 0
    # end
end

