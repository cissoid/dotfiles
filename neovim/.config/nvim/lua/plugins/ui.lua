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
