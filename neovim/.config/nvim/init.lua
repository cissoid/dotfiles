-- {{{ Base
do
    -- {{{ Base VIM Settings
    local base_settings = {
        ---------------- BASE ----------------
        compatible = false,
        encoding = "utf-8",
        fileencodings = "ucs-bom,utf-8,utf-16,gbk,default,latin1",
        -- updatetime = 200, -- CursorHold delay
        errorbells = false, -- ignore error bells
        visualbell = false,
        -- backspace = "indent,eol,start", -- macOS seems don't have own backspace setting.
        autoread = true, -- auto refresh when file changed outside
        mouse = "a", -- enable mouse support
        completeopt = "menu,menuone,noselect",
        hidden = true,

        ---------------- COLOR ----------------
        synmaxcol = 0,
        termguicolors = true, -- enable true color for terminal.
        background = "dark", -- tell vim we prefer dark background

        ---------------- UI ----------------
        -- show filename and other infos in terminal title
        title = true,
        showtabline = 2, -- always show tab line
        laststatus = 2, -- always show status line
        showmode = false,
        number = true,
        relativenumber = false,
        showcmd = true,
        cursorline = true,
        cursorcolumn = true,

        wildmenu = true,
        wildmode = "list:longest,full",
        wildignore = "*.o,*.swp,*.bak,*.pyc,*.zip",
        lazyredraw = true,
        -- ttyfast = true,
        showmatch = true,
        textwidth = 0,
        colorcolumn = "80,120",
        ruler = true,
        scrolloff = 10,
        listchars = [[tab:¦\ ,eol:¬,trail:⋅,extends:»,precedes:«]],

        pumblend = 20,
        winblend = 20,

        ---------------- SPACE / TAB ----------------
        tabstop = 4, -- number of visual spaces for tab
        softtabstop = 4, -- number of actual spaces for tab
        shiftwidth = 4, -- make << or >> step 4 spaces.
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
        foldlevelstart = 10, -- initial fold level 10
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
end
-- }}}

-- {{{ Packer
require("packer").startup(
    {
        -- plugins
        {
            -- {{{ let packer manage itself
            {
                "wbthomason/packer.nvim",
                -- config = function()
                --     vim.api.nvim_create_autocmd("BufWritePost", {
                --         group = vim.api.nvim_create_augroup("packer_auto_refresh", {}),
                --         pattern = "*/.config/nvim/init.lua",
                --         desc = "auto refresh init.lua",
                --         command = "source <afile> | PackerCompile"
                --     })
                -- end
            },
            -- }}}

            -- {{{ ---------------- UI ----------------
            {
                -- replace builtin updatetime
                "antoinemadec/FixCursorHold.nvim",
                setup = function()
                    vim.g.cursorhold_updatetime = 500
                end
            },
            {
                -- stabilize cursor position when quickfix open
                "luukvbaal/stabilize.nvim",
                config = function()
                    require("stabilize").setup()
                end
            },
            {
                "sainnhe/sonokai",
                setup = function()
                    vim.g.sonokai_enable_italic = 1
                    vim.g.sonokai_current_word = "underline"
                    vim.g.sonokai_diagnostic_text_highlight = 1
                    vim.g.sonokai_disable_terminal_colors = 1
                    vim.g.sonokai_better_performance = 1
                end,
                config = function()
                    vim.cmd([[
                            colorscheme sonokai

                            " CurrentWord with underline and background
                            let s:configuration = sonokai#get_configuration()
                            let s:palette = sonokai#get_palette(s:configuration.style, s:configuration.colors_override)
                            call sonokai#highlight("CurrentWord", s:palette.none, s:palette.bg2, s:configuration.current_word)
                        ]])
                end,
            },
            {
                -- colorful color code
                "norcalli/nvim-colorizer.lua",
                config = function()
                    require("colorizer").setup()
                end
            },
            {
                -- indent guide
                "lukas-reineke/indent-blankline.nvim",
                config = function()
                    require("indent_blankline").setup()
                end
            },
            {
                -- highlight current match
                "winston0410/range-highlight.nvim",
                requires = { "winston0410/cmd-parser.nvim" },
                config = function()
                    require("range-highlight").setup()
                end
            },
            {
                "kevinhwang91/nvim-hlslens",
                config = function()
                    require("hlslens").setup({
                        nearest_only = true,
                        nearest_float_when = "always",
                    })

                    vim.api.nvim_set_keymap('n', 'n',
                        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
                        { silent = true })
                    vim.api.nvim_set_keymap('n', 'N',
                        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
                        { silent = true })
                    vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], { silent = true })
                    vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], { silent = true })
                    vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]],
                        { silent = true })
                    vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]],
                        { silent = true })
                    vim.api.nvim_set_keymap('n', '<Leader>l', ':noh<CR>', { silent = true })
                end,
                disable = true,
            },
            {
                -- statusline
                "nvim-lualine/lualine.nvim",
                requires = { "kyazdani42/nvim-web-devicons" },
                after = { "sonokai" },
                config = function()
                    local utils = require("lualine.utils.utils")
                    require("lualine").setup({
                        options = {
                            icons_enabled = true,
                            theme = "sonokai",
                            component_separators = { left = "", right = "" },
                            section_separators = { left = "", right = "" },
                            always_divide_middle = true,
                            globalstatus = false,
                        },
                        sections = {
                            lualine_a = { "mode" },
                            lualine_b = {
                                "branch",
                                "diff",
                                {
                                    "diagnostics",
                                    diagnostics_color = {
                                        error = {
                                            fg = utils.extract_color_from_hllist("fg", { "RedSign" }, "#e32636"),
                                        },
                                        warn = {
                                            fg = utils.extract_color_from_hllist("fg", { "YellowSign" }, "#ffa500"),
                                        },
                                        info = {
                                            fg = utils.extract_color_from_hllist("fg", { "BlueSign" }, "#ffffff"),
                                        },
                                        hint = {
                                            fg = utils.extract_color_from_hllist("fg", { "GreenSign" }, "#273faf"),
                                        }
                                    }
                                },
                            },
                            lualine_c = { "filename" },
                            lualine_x = {
                                "filetype",
                                -- {
                                --     -- treesitter
                                --     function()
                                --         local bufferid = vim.api.nvim_get_current_buf()
                                --         if next(vim.treesitter.highlighter.active[bufferid]) then
                                --             return ""
                                --         end
                                --         return ""
                                --     end,
                                --     color = { fg = utils.extract_color_from_hllist('fg', { "GreenSign" }, "") },
                                -- }, {
                                --     function(msg)
                                --         msg = msg or "LS Inactive"
                                --         local buf_clients = vim.lsp.buf_get_clients()
                                --         if next(buf_clients) == nil then
                                --             -- TODO: clean up this if statement
                                --             if type(msg) == "boolean" or #msg == 0 then
                                --                 return "LS Inactive"
                                --             end
                                --             return msg
                                --         end
                                --         local buf_ft = vim.bo.filetype
                                --         local buf_client_names = {}
                                --
                                --         -- add client
                                --         for _, client in pairs(buf_clients) do
                                --             if client.name ~= "null-ls" then
                                --                 table.insert(buf_client_names, client.name)
                                --             end
                                --         end
                                --
                                --         -- add formatter
                                --         -- local formatters = require "lvim.lsp.null-ls.formatters"
                                --         -- local supported_formatters = formatters.list_registered(buf_ft)
                                --         -- vim.list_extend(buf_client_names, supported_formatters)
                                --
                                --         -- add linter
                                --         -- local linters = require "lvim.lsp.null-ls.linters"
                                --         -- local supported_linters = linters.list_registered(buf_ft)
                                --         -- vim.list_extend(buf_client_names, supported_linters)
                                --
                                --         local unique_client_names = vim.fn.uniq(buf_client_names)
                                --         return "[" .. table.concat(unique_client_names, ", ") .. "]"
                                --     end,
                                --     color = { gui = "bold" },
                                -- },
                            },
                            lualine_y = { "encoding", "fileformat" },
                            lualine_z = {
                                function()
                                    -- percentage, lineno and colno
                                    return "%p%% %l/%L:%v"
                                end
                            }
                        },
                        inactive_sections = {
                            lualine_a = {},
                            lualine_b = {},
                            lualine_c = { "filename" },
                            lualine_x = { "location" },
                            lualine_y = {},
                            lualine_z = {}
                        },
                        tabline = {},
                        extensions = {
                            "fugitive",
                            "man",
                            "nvim-dap-ui",
                            "nvim-tree",
                            "quickfix",
                            "symbols-outline",
                        }
                    })
                end
            },
            {
                -- tabline
                "akinsho/bufferline.nvim",
                requires = { "kyazdani42/nvim-web-devicons" },
                config = function()
                    require("bufferline").setup({
                        options = {
                            offsets = {
                                {

                                    filetype = "NvimTree",
                                    text = "Explorer",
                                    -- highlight = "Directory",
                                    -- text_align = "left",
                                },
                                {
                                    filetype = "Outline",
                                    text = "Outline",
                                }
                            }
                        }
                    })
                end
            },
            {
                "stevearc/dressing.nvim",
                config = function()
                    require("dressing").setup({
                        input = {
                            override = function(conf)
                                conf.col = -1
                                conf.row = 0
                                return conf
                            end,
                        },
                    })
                end,
            },
            {
                "karb94/neoscroll.nvim",
                config = function() require("neoscroll").setup() end
            },
            {
                -- modern notify
                "rcarriga/nvim-notify",
                after = { "telescope.nvim" },
                config = function()
                    require("notify").setup({
                        max_width = 80,
                        timeout = 2000,
                        fps = 60,
                    })

                    vim.notify = require("notify")
                    require("telescope").load_extension("notify")
                end
            },
            -- }}}

            -- {{{ ---------------- Keymaps ----------------
            {
                "kylechui/nvim-surround",
                config = function()
                    require("nvim-surround").setup()
                end
            },
            {
                "windwp/nvim-autopairs",
                config = function()
                    require("nvim-autopairs").setup({
                        check_ts = true,
                    })
                end
            },
            {
                "numToStr/Comment.nvim",
                config = function()
                    require("Comment").setup()

                    vim.keymap.set(
                        "n",
                        "<Leader>c<Space>",
                        "<Plug>(comment_toggle_current_linewise)",
                        { silent = true }
                    )
                end
            },
            {
                "phaazon/hop.nvim", -- easy motion
                config = function()
                    require("hop").setup()

                    vim.keymap.set("n", "<Leader><Leader>s", require("hop").hint_patterns, { silent = true })
                end
            },
            {
                "https://gitlab.com/yorickpeterse/nvim-window.git", -- quick window jump
                config = function()
                    require("nvim-window").setup({
                        chars = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n" },
                        normal_hl = "Normal",
                        hint_hl = "Bold",
                        border = "single"
                    })

                    vim.keymap.set("n", "<Leader>w", require("nvim-window").pick, { silent = true })
                end
            },
            {
                "toppair/reach.nvim",
                requires = { "kyazdani42/nvim-web-devicons" },
                config = function()
                    require("reach").setup()

                    local options = {
                        show_current = true,
                        modified_icon = "[+]",
                    }
                    local show_buffers = function()
                        return require("reach").buffers(options)
                    end

                    vim.keymap.set("n", "<Leader>gb", show_buffers, { silent = true })
                end
            },
            -- }}}

            -- {{{ ---------------- Explorer / Outline / Telescope ----------------
            {
                "kyazdani42/nvim-tree.lua",
                requires = { "kyazdani42/nvim-web-devicons" },
                config = function()
                    require("nvim-tree").setup({
                        hijack_cursor = true,
                        view = {
                            mappings = {
                                list = {
                                    { key = "s", action = "vsplit" },
                                    -- { key = 'l', action = "preview" },
                                },
                            },
                        },
                    })

                    vim.keymap.set("n", "<Leader>n", function()
                        -- handle [No Name] buffer
                        if vim.api.nvim_buf_get_name(0) == "" then
                            vim.cmd("NvimTreeFindFileToggle")
                        else
                            vim.cmd("NvimTreeFindFile")
                        end
                    end, { silent = false })
                end
            },
            {
                "simrat39/symbols-outline.nvim",
                after = { "sonokai" },
                setup = function()
                    vim.g.symbols_outline = {
                        width = 15, -- percentage
                        symbol_blacklist = { "Variable", "Constant", "String", "Number", "Boolean" },
                    }

                end,
                config = function()
                    vim.cmd("highlight! link FocusedSymbol BlueItalic")
                    vim.keymap.set("n", "<Leader>t", "<Cmd>SymbolsOutline<CR>", { silent = true })
                end
            },
            {
                "nvim-telescope/telescope.nvim",
                branch = "0.1.x",
                requires = { "nvim-lua/plenary.nvim" },
                config = function()
                    require("telescope").setup({
                        defaults = {
                            winblend = 10,
                            dynamic_preview_title = true,
                        }
                    })

                    vim.keymap.set("n", "<Leader>ff", require("telescope.builtin").builtin, { silent = true })
                    vim.keymap.set("n", "<Leader>fr", require("telescope.builtin").resume, { silent = true })
                    vim.keymap.set("n", "<Leader>fi", require("telescope.builtin").lsp_incoming_calls,
                        { silent = true })
                    vim.keymap.set("n", "<Leader>fo", require("telescope.builtin").lsp_outgoing_calls,
                        { silent = true })
                end
            },
            {
                "AckslD/nvim-neoclip.lua",
                requires = { "nvim-telescope/telescope.nvim" },
                config = function()
                    require("neoclip").setup()

                    -- workaround
                    require("telescope").load_extension("neoclip")

                    vim.keymap.set("n", "<Leader>y", "<Cmd>Telescope neoclip<CR>", { silent = true })
                end,
            },
            {
                "sudormrfbin/cheatsheet.nvim",
                requires = {
                    "nvim-telescope/telescope.nvim",
                    "nvim-lua/popup.nvim",
                    "nvim-lua/plenary.nvim",
                },
            },
            -- }}}

            -- {{{ ---------------- TREESITTER ----------------
            {
                "nvim-treesitter/nvim-treesitter",
                run = function()
                    require("nvim-treesitter.install").update({ with_sync = true })
                end,
                config = function()
                    require("nvim-treesitter.configs").setup({
                        ensure_installed = {
                            "bash", "c", "cmake", "comment", "cpp", "css", "dockerfile", "erlang", "go",
                            "gomod", "gowork", "help", "html", "http", "java", "javascript", "jsdoc", "json", "jsonc",
                            "latex", "lua", "make", "markdown", "markdown_inline", "php", "phpdoc", "proto", "python",
                            "regex", "rust", "scheme", "scss", "toml", "tsx", "typescript", "vim", "vue", "yaml",
                        },
                        highlight = {
                            enable = true,
                            -- additional_vim_regex_highlighting = true,
                        },
                        incremental_selection = {
                            enable = true,
                            keymaps = {
                                init_selection = "gnn",
                                node_incremental = "grn",
                                scope_incremental = "grc",
                                node_decremental = "grm",
                            }
                        },
                        indent = {
                            enable = false,
                        }
                    })

                    -- vim.opt["foldmethod"] = "expr"
                    -- vim.opt["foldexpr"] = "nvim_treesitter#foldexpr()"

                end
            },
            {
                "nvim-treesitter/nvim-treesitter-context", -- show floating hover with the current context
                requires = { "nvim-treesitter/nvim-treesitter" },
                config = function()
                    require("treesitter-context").setup()
                end
            },
            -- }}}

            -- {{{ ---------------- AUTOCOMPLETE ----------------
            {
                "hrsh7th/nvim-cmp",
                requires = {
                    { "hrsh7th/cmp-nvim-lsp" },
                    { "hrsh7th/cmp-buffer" },
                    { "hrsh7th/cmp-cmdline" },
                    { "hrsh7th/cmp-path" },
                    { "hrsh7th/cmp-nvim-lua" },
                    { "hrsh7th/cmp-nvim-lsp-signature-help" },
                    { "hrsh7th/cmp-nvim-lsp-document-symbol" },
                    { "onsails/lspkind.nvim" },
                },
                after = { "nvim-autopairs" },
                config = function()
                    local cmp = require("cmp")

                    cmp.setup({
                        mapping = cmp.mapping.preset.insert({
                            ["<Leader>y<Space>"] = cmp.mapping.complete(),
                            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                            ["<C-f>"] = cmp.mapping.scroll_docs(4),
                            ["<Tab>"] = cmp.mapping(function(fallback)
                                if cmp.visible() then
                                    cmp.select_next_item()
                                    -- cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
                                    -- elseif require('luasnip').expand_or_jumpable() then
                                    --   vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
                                else
                                    fallback()
                                end
                            end, { "i", "s" }),
                            ["<CR>"] = cmp.mapping.confirm({ select = true }),
                        }),
                        formatting = {
                            format = require("lspkind").cmp_format({
                                mode = "symbol",
                                menu = {
                                    buffer = "[Buffer]",
                                    nvim_lsp = "[LSP]",
                                }
                            })
                        },
                        sources = cmp.config.sources({
                            { name = "nvim_lsp" },
                            {
                                name = "buffer",
                                options = {
                                    get_bufnrs = function()
                                        return vim.api.nvim_list_bufs()
                                    end
                                },
                            },
                            { name = "nvim_lsp_signature_help" },
                            { name = "path" },
                        }),
                        experimental = {
                            ghost_text = true,
                        }
                    })

                    cmp.setup.cmdline(":", {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = {
                            { name = "cmdline" },
                            { name = "path" },
                        },
                    })

                    cmp.setup.cmdline("/", {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = {
                            { name = "buffer" },
                            { name = "nvim_lsp_document_symbol" },
                        },
                    })

                    cmp.event:on(
                        "confirm_done",
                        require("nvim-autopairs.completion.cmp").on_confirm_done()
                    )
                end
            },
            {
                "L3MON4D3/LuaSnip",
                requires = {
                    "rafamadriz/friendly-snippets",
                }
            },
            -- }}}

            -- {{{ ---------------- LSP ----------------
            {
                "williamboman/nvim-lsp-installer",
            },
            {
                "neovim/nvim-lspconfig",
                requires = { "williamboman/nvim-lsp-installer", "hrsh7th/cmp-nvim-lsp", "RRethy/vim-illuminate",
                    "nanotee/nvim-lsp-basics" },
                config = function()
                    -- first, install lsp server.
                    require("nvim-lsp-installer").setup({
                        ensure_installed = {
                            "pyright", "gopls", "clangd", "sumneko_lua",
                            "jsonls", "yamlls", "bashls", "vimls",
                        },
                        automatic_installation = true,
                    })

                    local function lsp_on_attach(client, bufnr)
                        vim.keymap.set("n", "<Leader>g<Space>", vim.lsp.buf.definition,
                            { silent = true, buffer = bufnr }) -- toggle fold
                        vim.keymap.set("n", "<Leader>fa", vim.lsp.buf.formatting, { silent = true, buffer = bufnr })
                        vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true, buffer = bufnr })

                        -- vim.api.nvim_create_autocmd({ "CursorHold" }, {
                        --     group = vim.api.nvim_create_augroup(string.format("lsp_autohold_buffer_%d", bufnr), {}),
                        --     buffer = bufnr,
                        --     desc = "lsp hover cursorhold",
                        --     callback = function()
                        --         vim.lsp.buf.hover({ focusable = false })
                        --     end,
                        -- })

                        require("illuminate").on_attach(client)
                        require("lsp_basics").make_lsp_commands(client, bufnr)
                    end

                    local cmp_capabilities = require("cmp_nvim_lsp").update_capabilities(
                        vim.lsp.protocol.make_client_capabilities()
                    )

                    -- global lsp diagnostic config
                    vim.diagnostic.config({
                        virtual_text = false,
                    })

                    require("lspconfig").pyright.setup({
                        on_attach = lsp_on_attach,
                        flags = {
                            debounce_text_changes = 150,
                        },
                        capabilities = cmp_capabilities,
                        handlers = {
                            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                                vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
                            )
                        },
                        settings = {
                            pyright = {

                            },
                            python = {
                                analysis = {
                                    diagnosticMode = "openFilesOnly",
                                    typeCheckingMode = "off",
                                },
                            }
                        },
                    })

                    require("lspconfig").sumneko_lua.setup({
                        on_attach = lsp_on_attach,
                        flags = {
                            debounce_text_changes = 150,
                        },
                        capabilities = cmp_capabilities,
                        settings = {
                            Lua = {
                                completion = {
                                    callSnippet = "Replace",
                                    -- displayContext = 10,
                                },
                                format = {
                                    defaultConfig = {
                                        indent_style = "space",
                                        quote_style = "double",
                                        enable_check_codestyle = true,
                                    }
                                },
                                diagnostics = {
                                    disable = {},
                                    globals = { "vim" },
                                },
                                workspace = {
                                    -- library = vim.api.nvim_get_runtime_file("", true),
                                },
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                        handlers = {
                            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                                vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
                            )
                        },
                    })

                    require("lspconfig").html.setup({
                        on_attach = lsp_on_attach,
                        capabilities = cmp_capabilities,
                        handlers = {
                            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                                vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
                            )
                        },
                    })

                end,
            },
            {
                -- lsp progress bar
                "j-hui/fidget.nvim",
                config = function()
                    require("fidget").setup({
                        text = {
                            spinner = "dots",
                        },
                    })
                end
            },
            {
                "folke/trouble.nvim", -- better diagnostics list
                requires = { "kyazdani42/nvim-web-devicons" },
                config = function()
                    require("trouble").setup({
                        mode = "document_diagnostics",
                        auto_close = true,
                        auto_preview = false,
                    })

                    vim.keymap.set(
                        "n", "<Leader>ss",
                        function()
                            vim.cmd("TroubleToggle")
                            vim.cmd("cclose")
                            vim.cmd("lclose")
                        end,
                        { silent = true })
                end
            },
            {
                "jose-elias-alvarez/null-ls.nvim",
                config = function()
                    require("null-ls").setup({
                        sources = {
                            require("null-ls").builtins.code_actions.gitsigns,
                            require("null-ls").builtins.code_actions.refactoring,
                            require("null-ls").builtins.code_actions.shellcheck,
                            -- python
                            require("null-ls").builtins.diagnostics.flake8,
                            require("null-ls").builtins.diagnostics.pylint,
                            require("null-ls").builtins.formatting.isort,
                            require("null-ls").builtins.formatting.black.with({
                                args = { "--line-length", "120", "--stdin-filename", "$FILENAME", "--quiet", "-" },
                            }),
                            -- lua
                            -- require("null-ls").builtins.formatting.stylua,
                            -- protobuf
                            require("null-ls").builtins.diagnostics.buf,
                            require("null-ls").builtins.diagnostics.protoc_gen_lint,
                            require("null-ls").builtins.diagnostics.protolint,
                        },
                    })
                end
            },
            {
                "weilbith/nvim-code-action-menu",
                cmd = "CodeActionMenu",
            },
            {
                "kosayoda/nvim-lightbulb",
                requires = { "antoinemadec/FixCursorHold.nvim" },
                config = function()
                    require("nvim-lightbulb").setup({
                        autocmd = {
                            enable = true
                        },
                    })
                end
            },
            {
                "smjonas/inc-rename.nvim",
                config = function()
                    require("inc_rename").setup()
                end,
                disable = true,
                -- cmd = "IncRename",
            },
            -- }}}

            -- {{{ ---------------- DAP ----------------
            {
                "Pocco81/dap-buddy.nvim",
                disable = true,
            },
            {
                "mfussenegger/nvim-dap",
            },
            {
                "rcarriga/nvim-dap-ui",
                requires = { "mfussenegger/nvim-dap" },
                config = function()
                    require("dapui").setup()

                    vim.keymap.set("n", "<Leader>d<Space>", require("dapui").toggle, { silent = true })
                end,
            },
            -- }}}

            -- {{{ ---------------- Git ----------------
            {
                "tpope/vim-fugitive",
            },
            {
                "lewis6991/gitsigns.nvim",
                config = function()
                    require("gitsigns").setup()
                end
            },
            {
                "sindrets/diffview.nvim",
                requires = { "nvim-lua/plenary.nvim" },
            },
            -- }}}

            -- {{{ ---------------- Misc ----------------
            {
                "akinsho/toggleterm.nvim",
                config = function()
                    require("toggleterm").setup({
                        direction = "float",
                    })

                    vim.keymap.set({ "n", "t" }, "<C-t>", "<Cmd>ToggleTerm<CR>", { silent = true })
                end
            },
            {
                "ellisonleao/glow.nvim",
                config = function()
                    require("glow").setup()
                end
            },
            -- }}}
        },

        -- config
        config = {
            display = {
                open_fn = require("packer.util").float,
            }
        }
    }
)
-- }}}

-- Neovide GUI {{{
do
    if vim.g.neovide ~= nil then
        vim.g.neovide_cursor_vfx_mode = "railgun"

        vim.opt.guifont = "Monaco Nerd Font:h14"
    end
end
-- }}}

-- vim: foldmethod=marker foldlevel=0
