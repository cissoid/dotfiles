return {
    {
        "sainnhe/sonokai",
        lazy = false,
        priority = 1000,
        init = function()
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
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VimEnter",
        opts = {
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
                                return "[P]"
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
                    "searchcount",
                    {
                        "filename",
                        path = 1,
                    },
                },
                lualine_x = {
                    "filetype",
                    {
                        -- treesitter
                        function()
                            local bufferid = vim.api.nvim_get_current_buf()
                            if next(vim.treesitter.highlighter.active[bufferid]) then
                                return ""
                            end
                            return ""
                        end,
                        color = function()
                            local utils = require("lualine.utils.utils")
                            return {
                                fg = utils.extract_color_from_hllist('fg', { "GreenSign" }, "")
                            }
                        end,
                    },
                    {
                        function(msg)
                            msg = msg or "LS Inactive"
                            local buf_clients = vim.lsp.buf_get_clients()
                            if next(buf_clients) == nil then
                                -- TODO: clean up this if statement
                                if type(msg) == "boolean" or #msg == 0 then
                                    return "LS Inactive"
                                end
                                return msg
                            end
                            local buf_ft = vim.bo.filetype
                            local buf_client_names = {}

                            -- add client
                            for _, client in pairs(buf_clients) do
                                if client.name ~= "null-ls" then
                                    table.insert(buf_client_names, client.name)
                                end
                            end

                            -- add formatter
                            -- local formatters = require "lvim.lsp.null-ls.formatters"
                            -- local supported_formatters = formatters.list_registered(buf_ft)
                            -- vim.list_extend(buf_client_names, supported_formatters)

                            -- add linter
                            -- local linters = require "lvim.lsp.null-ls.linters"
                            -- local supported_linters = linters.list_registered(buf_ft)
                            -- vim.list_extend(buf_client_names, supported_linters)

                            local unique_client_names = vim.fn.uniq(buf_client_names)
                            return "[" .. table.concat(unique_client_names, ", ") .. "]"
                        end,
                        color = { gui = "bold" },
                    },
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
        },
    },

    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VimEnter",
        opts = {
            options = {
                -- separator_style = "thick",
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
        },
    },

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
        "folke/trouble.nvim", -- better diagnostics list
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            {
                "folke/todo-comments.nvim",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                },
                keys = {
                    {
                        "<Leader>st",
                        function()
                            if vim.bo.filetype == "Trouble" then
                                vim.cmd("TroubleClose")
                                return
                            end
                            local current_file = vim.api.nvim_buf_get_name(0)
                            vim.cmd("TroubleToggle todo cwd=" .. current_file)
                            vim.cmd("cclose")
                            vim.cmd("lclose")
                        end,
                        silent = true,
                        desc = "open todo list in current file"
                    }
                },
                optional = true,
            }
        },
        keys = {
            {
                "<Leader>ss",
                function()
                    vim.cmd("TroubleToggle document_diagnostics")
                    vim.cmd("cclose")
                    vim.cmd("lclose")
                end,
                silent = true,
                desc = "trouble toggle",
            },
        },
        opts = {
            mode = "document_diagnostics",
            auto_close = true,
            auto_preview = false,
        },
    },

    {
        "rcarriga/nvim-notify",
        dependencies = { "nvim-telescope/telescope.nvim" },
        event = "VeryLazy",
        opts = {
            timeout = 2000,
            fps = 60,
        },
        config = function(_, opts)
            require("notify").setup(opts)
            vim.notify = require("notify")

            require("telescope").load_extension("notify")
        end,
    },

    {
        "folke/noice.nvim",
        enabled = false,
        dependencies = {
            { "MunifTanjim/nui.nvim" },
            { "rcarriga/nvim-notify" },
        },
        event = "VeryLazy",
        opts = {
            cmdline = {
                view = "cmdline",
            },
            messages = {
                enabled = false,
                view_search = false,
            },
            popupmenu = {
                enabled = false,
            },
            notify = {
                enabled = false,
            },
            lsp = {
                progress = {
                    enabled = false,
                },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                signature = {
                    enabled = false,
                },
                message = {
                    enabled = false,
                }
            },
            health = {
                checker = false,
            },
            presets = {
                bottom_search = true,
                -- command_palette = true,
                long_message_to_split = true,
                -- inc_rename = false,
                lsp_doc_border = true,
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "written",
                    },
                    opts = {
                        skip = true
                    }
                }
            }
        },
    },

    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = false,
            highlight = {
                keyword = "wide",
                after = "",
            },
        },
    },

    {
        "folke/zen-mode.nvim",
        dependencies = {
            {
                "folke/twilight.nvim",
                opts = {},
            },
        },
        cmd = "ZenMode",
        opts = {
            window = {
                width = 150,
            }
        },
    },

    {
        "akinsho/toggleterm.nvim",
        keys = {
            { "<C-t>", "<Cmd>ToggleTerm<CR>", mode = { "n", "t" }, silent = true, desc = "ToggleTerm" },
        },
        opts = {
            direction = "float",
        }
    },

    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        config = true,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        opts = { show_current_context = true },
    },

    {
        "winston0410/range-highlight.nvim",
        dependencies = { "winston0410/cmd-parser.nvim" },
        event = "VeryLazy",
        -- event = { "BufReadPost", "BufNewFile" },
        config = true,
    },


    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            input = {
                override = function(conf)
                    conf.col = -1
                    conf.row = 0
                    return conf
                end,
            },
        },
    },

    {
        "norcalli/nvim-colorizer.lua",
        ft = "css",
        config = true,
    },
}
