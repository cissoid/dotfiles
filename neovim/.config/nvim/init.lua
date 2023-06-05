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
        mouse = "a",     -- enable mouse support
        completeopt = "menu,menuone,noselect",
        hidden = true,
        ---------------- COLOR ----------------
        synmaxcol = 0,
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
        lazyredraw = true,
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
                "sainnhe/sonokai",
                setup = function()
                    vim.g.sonokai_enable_italic = 1
                    vim.g.sonokai_current_word = "underline"
                    vim.g.sonokai_diagnostic_text_highlight = 1
                    -- vim.g.sonokai_disable_terminal_colors = 1
                    -- vim.g.sonokai_better_performance = 1
                end,
                config = function()
                    vim.cmd([[
                            colorscheme sonokai

                            " CurrentWord with underline and background
                            let s:configuration = sonokai#get_configuration()
                            let s:palette = sonokai#get_palette(s:configuration.style, s:configuration.colors_override)
                            call sonokai#highlight("CurrentWord", s:palette.none, s:palette.bg2, s:configuration.current_word)
                            call sonokai#highlight("DiffDelete", s:palette.bg4, s:palette.bg0)
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
                    require("indent_blankline").setup({
                        show_current_context = true,
                    })
                end,
            },
            {
                -- highlight current range match
                "winston0410/range-highlight.nvim",
                requires = { "winston0410/cmd-parser.nvim" },
                config = function()
                    require("range-highlight").setup()
                end
            },
            {
                -- statusline
                "nvim-lualine/lualine.nvim",
                requires = { "kyazdani42/nvim-web-devicons" },
                after = { "sonokai" },
                config = function()
                    require("lualine").setup({
                        options = {
                            icons_enabled = true,
                            theme = "auto",
                            component_separators = { left = "", right = "" },
                            section_separators = { left = "", right = "" },
                            always_divide_middle = true,
                            globalstatus = false,
                        },
                        sections = {
                            lualine_a = {
                                "mode",
                                {
                                    function()
                                        if vim.o.paste then
                                            return "[PASTE]"
                                        end
                                        return ""
                                    end,
                                },
                            },
                            lualine_b = {
                                "branch",
                                "diff",
                                "diagnostics",
                            },
                            lualine_c = {
                                {
                                    "filename",
                                    path = 1,
                                },
                            },
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
                            "trouble",
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
                            separator_style = "thick",
                            offsets = {
                                {
                                    filetype = "NvimTree",
                                    text = "",
                                    -- highlight = "Directory",
                                    -- text_align = "left",
                                },
                                {
                                    filetype = "Outline",
                                    text = "",
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
                        -- max_width = 80,
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
            -- }}}

            -- {{{ ---------------- Explorer / Outline / Telescope ----------------
            {
                "kyazdani42/nvim-tree.lua",
                requires = { "kyazdani42/nvim-web-devicons" },
                config = function()
                    require("nvim-tree").setup({
                        hijack_cursor = true,
                        view = {
                            float = {
                                enable = false,
                                open_win_config = function()
                                    local HEIGHT_RATIO = 0.8
                                    local WIDTH_RATIO = 0.5

                                    local screen_w = vim.opt.columns:get()
                                    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                                    local window_w = screen_w * WIDTH_RATIO
                                    local window_h = screen_h * HEIGHT_RATIO
                                    local window_w_int = math.floor(window_w)
                                    local window_h_int = math.floor(window_h)
                                    local center_x = (screen_w - window_w) / 2
                                    local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                                    return {
                                        border = 'rounded',
                                        relative = 'editor',
                                        row = center_y,
                                        col = center_x,
                                        width = window_w_int,
                                        height = window_h_int,
                                    }
                                end,
                            },
                            -- width = function()
                            --     local WIDTH_RATIO = 0.5
                            --     return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                            -- end
                        },
                        renderer = {
                            indent_markers = {
                                enable = true,
                            }
                        },
                        on_attach = function(bufnr)
                            local api = require("nvim-tree.api")
                            api.config.mappings.default_on_attach(bufnr)

                            local function opts(desc)
                                return {
                                    desc = "nvim-tree: " .. desc,
                                    buffer = bufnr,
                                    noremap = true,
                                    silent = true,
                                    nowait = true
                                }
                            end
                            vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
                        end,
                    })

                    vim.keymap.set("n", "<Leader>n", function()
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
                config = function()
                    require("symbols-outline").setup({
                        width = 15,
                        symbol_blacklist = { "Variable", "Constant", "String", "Number", "Boolean" },
                    })
                    vim.cmd("highlight! link FocusedSymbol BlueItalic")
                    vim.keymap.set("n", "<Leader>t", "<Cmd>SymbolsOutline<CR>", { silent = true })
                end
            },
            {
                "glepnir/lspsaga.nvim",
                requires = {
                    "nvim-tree/nvim-web-devicons",
                    "nvim-treesitter/nvim-treesitter",
                },
                opt = true,
                event = "LspAttach",
                config = function()
                    require("lspsaga").setup({
                        symbol_in_winbar = {
                            enable = false
                        }
                    })
                end,
            },
            {
                "nvim-telescope/telescope.nvim",
                branch = "0.1.x",
                requires = {
                    "nvim-lua/plenary.nvim",
                    "nvim-telescope/telescope-fzf-native.nvim",
                },
                config = function()
                    require("telescope").setup({
                        defaults = {
                            sorting_strategy = "ascending",
                            layout_config = {
                                horizontal = {
                                    prompt_position = "top",
                                }
                            },
                            winblend = 0,
                            results_title = false,
                            dynamic_preview_title = true,
                        }
                    })

                    require("telescope").load_extension("fzf")

                    vim.keymap.set("n", "<Leader>ft", require("telescope.builtin").builtin, { silent = true })
                    vim.keymap.set("n", "<Leader>ff", require("telescope.builtin").find_files, { silent = true })
                    vim.keymap.set("n", "<Leader>fg", require("telescope.builtin").live_grep, { silent = true })
                    vim.keymap.set("n", "<Leader>fb", require("telescope.builtin").buffers, { silent = true })
                    vim.keymap.set("n", "<Leader>fr", require("telescope.builtin").resume, { silent = true })
                    vim.keymap.set("n", "<Leader>fi", require("telescope.builtin").lsp_incoming_calls,
                        { silent = true })
                    vim.keymap.set("n", "<Leader>fo", require("telescope.builtin").lsp_outgoing_calls,
                        { silent = true })
                end
            },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                run = "make"
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
                            -- "bash", "c", "cmake", "comment", "cpp", "css", "dockerfile", "erlang", "go",
                            -- "gomod", "gowork", "help", "html", "http", "java", "javascript", "jsdoc", "json", "jsonc",
                            -- "latex", "lua", "make", "markdown", "markdown_inline", "php", "phpdoc", "proto", "python",
                            -- "regex", "rust", "scheme", "scss", "toml", "tsx", "typescript", "vim", "vue", "yaml",
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
                    { "L3MON4D3/LuaSnip" },
                    { "saadparwaiz1/cmp_luasnip" },
                    -- { "zbirenbaum/copilot-cmp" },
                },
                after = { "nvim-autopairs" },
                config = function()
                    local cmp = require("cmp")

                    local function has_words_before()
                        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
                            return false
                        end
                        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                        return col ~= 0 and
                            vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                    end

                    cmp.setup({
                        snippet = {
                            expand = function(args)
                                require("luasnip").lsp_expand(args.body)
                            end
                        },
                        window = {
                            completion = cmp.config.window.bordered(),
                            documentation = cmp.config.window.bordered(),
                        },
                        mapping = cmp.mapping.preset.insert({
                            ["<Leader>g<Space>"] = cmp.mapping.complete(),
                            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                            ["<C-f>"] = cmp.mapping.scroll_docs(4),
                            ["<Tab>"] = cmp.mapping(function(fallback)
                                if cmp.visible() then
                                    cmp.select_next_item()
                                elseif require("luasnip").expand_or_jumpable() then
                                    require("luasnip").expand_or_jump()
                                elseif has_words_before() then
                                    cmp.complete()
                                else
                                    fallback()
                                end
                            end, { "i", "s" }),
                            ["<S-Tab>"] = cmp.mapping(function(fallback)
                                if cmp.visible() then
                                    cmp.select_prev_item()
                                elseif require("luasnip").jumpable(-1) then
                                    require("luasnip").jump(-1)
                                else
                                    fallback()
                                end
                            end, { "i", "s" }),
                            ["<CR>"] = cmp.mapping.confirm({ select = true }),
                        }),
                        formatting = {
                            format = function(entry, vim_item)
                                if vim.tbl_contains({ "path" }, entry.source.name) then
                                    local icon, hl_group = require("nvim-web-devicons").get_icons(entry:
                                    get_completion_item().label)
                                    if icon then
                                        vim_item.kind = icon
                                        vim_item.kind_hl_group = hl_group
                                        return vim_item
                                    end
                                end
                                return require("lspkind").cmp_format({
                                    mode = "symbol",
                                    menu = {
                                        buffer = "[Buffer]",
                                        nvim_lsp = "[LSP]",
                                        luasnip = "[LuaSnip]",
                                        nvim_lua = "[Lua]",
                                        latex_symbols = "[Latex]",
                                        copilot = "[Copilot]",
                                    },
                                    symbol_map = { Copilot = "" },
                                })(entry, vim_item)
                            end,
                        },
                        sources = cmp.config.sources({
                            -- { name = "copilot" },
                            { name = "nvim_lsp" },
                            { name = "luasnip" },
                            {
                                name = "buffer",
                                options = {
                                    get_bufnrs = function()
                                        return vim.api.nvim_list_bufs()
                                    end
                                },
                            },
                            { name = "nvim_lsp_signature_help" },
                            -- { name = "path" },
                        }),
                        experimental = {
                            ghost_text = true,
                        }
                    })

                    cmp.setup.filetype("gitcommit", {
                        sources = cmp.config.sources({
                            { name = 'cmp_git' },
                        })
                    })

                    cmp.setup.cmdline(":", {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = {
                            { name = "cmdline" },
                            -- { name = "path" },
                        },
                    })

                    cmp.setup.cmdline("/", {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = {
                            { name = "buffer" },
                            { name = "nvim_lsp_document_symbol" },
                        },
                    })

                    cmp.event:on("menu_opened", function()
                        vim.b.copilot_suggestion_hidden = true
                    end)
                    cmp.event:on("menu_closed", function()
                        vim.b.copilot_suggestion_hidden = false
                    end)
                    cmp.event:on(
                        "confirm_done",
                        require("nvim-autopairs.completion.cmp").on_confirm_done()
                    )
                end
            },
            {
                "zbirenbaum/copilot.lua",
                disable=True,
                cmd = "Copilot",
                event = "InsertEnter",
                config = function()
                    require("copilot").setup({
                        suggestion = {
                            enabled = true,
                            auto_trigger = true,
                            keymap = {
                                accept = "<Leader><Tab>",
                                next = "<Leader>]",
                                prev = "<Leader>[",
                                dismiss = "<Leader><Space>",
                            }
                        },
                        panel = { enabled = true }
                    })
                end
            },
            {
                "zbirenbaum/copilot-cmp",
                disable=true,
                after = { "copilot.lua" },
                config = function()
                    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
                    require("copilot_cmp").setup()
                end,
            },
            {
                "L3MON4D3/LuaSnip",
                requires = {
                    "rafamadriz/friendly-snippets",
                },
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end
            },
            -- }}}

            -- {{{ ---------------- LSP ----------------
            {
                "neovim/nvim-lspconfig",
                config = function()
                    -- global lsp diagnostic config
                    vim.diagnostic.config({
                        virtual_text = false,
                        severity_sort = true,
                    })
                end
            },
            {
                "williamboman/mason.nvim",
                config = function()
                    require("mason").setup()
                end
            },
            {
                "williamboman/mason-lspconfig.nvim",
                requires = {
                    "neovim/nvim-lspconfig",
                    "williamboman/mason.nvim",
                    "hrsh7th/cmp-nvim-lsp",
                    "RRethy/vim-illuminate",
                    "nanotee/nvim-lsp-basics",
                },
                after = {
                    "mason.nvim",
                },
                config = function()
                    require("mason-lspconfig").setup()

                    local function lsp_on_attach(client, bufnr)
                        vim.keymap.set("n", "<Leader>g<Space>", vim.lsp.buf.definition, { silent = true, buffer = bufnr })
                        -- vim.keymap.set("n", "<Leader>gr", require("telescope").lsp_references, { silent = true, buffer = bufnr })
                        vim.keymap.set("n", "<Leader>fa", function() vim.lsp.buf.format({ async = true }) end,
                            { silent = true, buffer = bufnr })
                        vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true, buffer = bufnr })

                        vim.api.nvim_create_autocmd({ "CursorHold" }, {
                            group = vim.api.nvim_create_augroup(string.format("lsp_autohold_buffer_%d", bufnr), {}),
                            buffer = bufnr,
                            desc = "lsp hover cursorhold",
                            callback = function()
                                -- vim.lsp.buf.hover({ focusable = false })
                                vim.diagnostic.open_float({
                                    severity_sort = true,
                                    format = function(diag)
                                        local msg = diag.source
                                        if diag.code then
                                            msg = msg .. "(" .. diag.code .. ")"
                                        end
                                        msg = msg .. ": " .. diag.message
                                        return msg
                                    end
                                })
                            end,
                        })

                        require("illuminate").on_attach(client)
                        require("lsp_basics").make_lsp_commands(client, bufnr)
                    end

                    local function lsp_config(custom, override_encoding)
                        local settings = {
                            on_attach = lsp_on_attach,
                            flags = {
                                debounce_text_changes = 150,
                            },
                            capabilities = require("cmp_nvim_lsp").default_capabilities(),
                            handlers = {
                                ["textDocument/publishDiagnostics"] = vim.lsp.with(
                                    vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
                                )
                            },
                        }
                        if override_encoding ~= nil then
                            settings.capabilities.offsetEncoding = { "utf-16" }
                        end
                        for k, v in pairs(custom) do
                            settings[k] = v
                        end
                        return settings
                    end

                    require("mason-lspconfig").setup_handlers({
                        function(server_name)
                            require("lspconfig")[server_name].setup(lsp_config({}))
                        end,
                        clangd = function()
                            require("lspconfig").clangd.setup(lsp_config({}, true))
                        end,
                        pyright = function()
                            require("lspconfig").pyright.setup(
                                lsp_config({
                                    settings = {
                                        pyright = {

                                        },
                                        python = {
                                            analysis = {
                                                diagnosticMode = "openFilesOnly",
                                                typeCheckingMode = "off",
                                            },
                                        },
                                    }
                                })
                            )
                        end,
                        gopls = function()
                            require("lspconfig").gopls.setup(
                                lsp_config({
                                    settings = {
                                        gopls = {
                                            gofumpt = true,
                                            analyses = {
                                                fieldalignment = true,
                                                nilness = true,
                                                shadow = true,
                                                unusedparams = true,
                                                unusedwrite = true,
                                                useany = true,
                                                unusedvariable = true,
                                            },
                                            staticcheck = true,
                                        }
                                    }
                                })
                            )
                        end,
                        lua_ls = function()
                            require("lspconfig").lua_ls.setup(
                                lsp_config({
                                    settings = {
                                        Lua = {
                                            runtime = {
                                                version = "LuaJIT",
                                            },
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
                                })
                            )
                        end,
                        yamlls = function()
                            require("lspconfig").yamlls.setup(
                                lsp_config({
                                    settings = {
                                        yaml = {
                                            format = {
                                                enable = true,
                                            },
                                            validate = true,
                                            hover = true,
                                            completion = true
                                        }
                                    }
                                })
                            )
                        end
                    })
                end
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
                        on_init = function(new_client, _)
                            new_client.offset_encoding = 'utf-16'
                        end,
                        sources = {
                            -- common
                            require("null-ls").builtins.code_actions.refactoring,
                            require("null-ls").builtins.code_actions.shellcheck,
                            -- python
                            require("null-ls").builtins.diagnostics.flake8.with({
                                args = {
                                    "--config", "~/.config/flake8", "--format", "default", "--stdin-display-name",
                                    "$FILENAME", "-"
                                },
                            }),
                            require("null-ls").builtins.diagnostics.pylint,
                            require("null-ls").builtins.formatting.isort,
                            require("null-ls").builtins.formatting.black.with({
                                args = { "--line-length", "120", "--stdin-filename", "$FILENAME", "--quiet", "-" },
                            }),
                            -- go
                            require("null-ls").builtins.diagnostics.golangci_lint,
                            require("null-ls").builtins.diagnostics.revive,
                            require("null-ls").builtins.diagnostics.staticcheck,
                            require("null-ls").builtins.formatting.gofumpt,
                            require("null-ls").builtins.formatting.goimports,
                            -- lua
                            -- require("null-ls").builtins.formatting.stylua,
                            -- protobuf
                            require("null-ls").builtins.diagnostics.buf,
                            require("null-ls").builtins.diagnostics.protoc_gen_lint,
                            require("null-ls").builtins.diagnostics.protolint,
                            -- sql
                            require("null-ls").builtins.diagnostics.sqlfluff,
                            -- json
                            require("null-ls").builtins.formatting.prettier,
                            -- fish
                            require("null-ls").builtins.diagnostics.fish,
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
                config = function()
                    require("nvim-lightbulb").setup({
                        autocmd = {
                            enable = true
                        },
                    })
                end
            },
            -- }}}

            -- {{{ ---------------- DAP ----------------
            {
                "mfussenegger/nvim-dap",
                config = function()
                    local dap = require("dap");

                    dap.adapters.python = {
                        type = "executable",
                        command = "debugpy-adapter",
                    }
                    dap.configurations.python = {
                        {
                            type = "python",
                            request = "launch",
                            name = "Launch file",
                            program = "${file}",
                            pythonPath = function() return "python" end,
                        }
                    }
                end
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
                "TimUntersberger/neogit",
                requires = {
                    "nvim-lua/plenary.nvim"
                },
                config = function()
                    require("neogit").setup()
                end
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
                config = function()
                    require("diffview").setup({
                        view = {
                            merge_tool = {
                                layout = "diff4_mixed"
                            }
                        }
                    })
                end
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
        vim.opt.guifont = "Monaco Nerd Font:h14"
        vim.g.neovide_no_idle = true
        -- vim.g.neovide_cursor_vfx_mode = "railgun"
        -- vim.g.neovide_scroll_animation_Length = 0.1

        vim.g.neovide_input_use_logo = 1
        vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
    end
end
-- }}}

-- vim: foldmethod=marker foldlevel=0
