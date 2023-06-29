return {
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            {

                "<Leader>n",
                function()
                    if vim.api.nvim_buf_get_name(0) == "" then
                        vim.cmd("NvimTreeFindFileToggle")
                    else
                        vim.cmd("NvimTreeFindFile")
                    end
                end,
                silent = true,
                desc = "nvim-tree toggle",
            },
        },
        opts = {
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
        },
    },

    {
        "simrat39/symbols-outline.nvim",
        event = "LspAttach",
        keys = { { "<Leader>t", "<Cmd>SymbolsOutline<CR>", silent = true, desc = "symbols outline toggle" } },
        opts = {
            width = 15,
            symbol_blacklist = { "Variable", "Constant", "String", "Number", "Boolean" },
        },
        config = function(_, opts)
            require("symbols-outline").setup(opts)
            vim.cmd("highlight! link FocusedSymbol BlueItalic")
        end
    },

    {
        "kylechui/nvim-surround",
        event = { "BufReadPost", "BufNewFile" },
        config = true,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = { check_ts = true },
    },

    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = true,
    },

    {
        "phaazon/hop.nvim",
        keys = {
            {
                "<Leader><Leader>s",
                function() return require("hop").hint_patterns() end,
                silent = true,
                desc = "easy motion",
            },
        },
        config = true,
    },
}
