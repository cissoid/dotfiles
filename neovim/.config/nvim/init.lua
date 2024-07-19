if vim.loader then
    vim.loader.enable()
end

-- {{{ Base
do
    -- {{{ Base VIM Settings
    local base_settings = {
        ---------------- BASE ----------------
        compatible = false,
        encoding = "utf-8",
        fileencodings = "ucs-bom,utf-8,utf-16,gbk,default,latin1",
        updatetime = 1000,  -- CursorHold delay
        errorbells = false, -- ignore error bells
        visualbell = false,
        -- backspace = "indent,eol,start", -- macOS seems don't have own backspace setting.
        autoread = true, -- auto refresh when file changed outside
        mouse = "a",     -- enable mouse support
        completeopt = "menu,menuone,noselect",
        hidden = true,
        clipboard = { "unnamedplus" },
        shortmess = "filnxtToOCFmrsc",
        ---------------- COLOR ----------------
        -- synmaxcol = 0,
        termguicolors = true, -- enable true color for terminal.
        background = "dark",  -- tell vim we prefer dark background
        ---------------- UI ----------------
        -- show filename and other infos in terminal title
        title = true,
        showtabline = 2, -- always show tab line
        laststatus = 2,  -- always show status line
        showmode = false,
        number = true,
        relativenumber = false,
        showcmd = true,
        cursorline = true,
        cursorcolumn = true,
        wildmenu = true,
        wildmode = "list:longest,full",
        wildignore = "*.o,*.swp,*.bak,*.pyc,*.zip",
        lazyredraw = false,
        -- ttyfast = true,
        showmatch = true,
        textwidth = 0,
        colorcolumn = "80,120",
        ruler = true,
        scrolloff = 10,
        listchars = [[tab:¦\ ,eol:¬,trail:⋅,extends:»,precedes:«]],
        fillchars = [[diff:╱]],
        pumblend = 20,
        winblend = 20,
        splitkeep = "screen",
        ---------------- SPACE / TAB ----------------
        tabstop = 4,      -- number of visual spaces for tab
        softtabstop = 4,  -- number of actual spaces for tab
        shiftwidth = 4,   -- make << or >> step 4 spaces.
        expandtab = true, -- convert tabe to space
        -- smarttab=true,
        autoindent = true,
        -- smartindent=true,

        ---------------- SEARCH ----------------
        hlsearch = true,
        ignorecase = true,
        incsearch = true,
        ---------------- FOLD ----------------
        foldenable = true,
        foldmethod = "indent", -- fold based on indent level.
        foldlevelstart = 10,   -- initial fold level 10
        foldlevel = 99,
        foldnestmax = 10,
    }

    for key, value in pairs(base_settings) do
        vim.opt[key] = value
    end
    -- }}}

    -- {{{ Base Keymaps
    vim.keymap.set("n", "j", 'v:count == 0 ? "gj" : "j"', { silent = true, expr = true })
    vim.keymap.set("n", "k", 'v:count == 0 ? "gk" : "k"', { silent = true, expr = true })
    vim.keymap.set("n", "<C-j>", "j<C-e>")
    vim.keymap.set("n", "<C-k>", "k<C-y>")
    vim.keymap.set("n", "<Space>", "za") -- toggle fold

    vim.keymap.set("i", "jk", "<ESC>")
    -- }}}

    -- {{{ Base functions
    -- vim.api.nvim_add_user_command("SudoW", ":w !sudo tee % >/dev/null")
    -- }}}

    -- {{{ AutoCmd
    -- vim.api.nvim_create_augroup("AutoView", {})
    -- vim.api.nvim_create_autocmd("BufWinLeave", { group = "AutoView", pattern = "*.*", command = "mkview!" })
    -- vim.api.nvim_create_autocmd("BufWinEnter", { group = "AutoView", pattern = "*.*", command = "silent! loadview" })
    -- }}}
end
-- }}}

-- {{{ Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {
        { import = "plugins.ui" },
        { import = "plugins.editor" },
        { import = "plugins.treesitter" },
        { import = "plugins.telescope" },
        { import = "plugins.lsp" },
        { import = "plugins.cmp" },
        { import = "plugins.git" },
        { import = "plugins.dap" },
        { import = "plugins.misc" },
    },
    {
        defaults = {
            lazy = true,
        },
        install = {
            colorscheme = { "sonokai" }
        },
        change_detection = {
            enabled = false,
        },
        performance = {
            cache = {
                enabled = true,
            },
            rtp = {
                disabled_plugins = {
                }
            },
        },
    }
)
-- }}}

require("editor.neovide")

-- vim: foldmethod=marker foldlevel=0
