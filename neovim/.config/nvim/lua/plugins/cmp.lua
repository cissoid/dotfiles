return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "hrsh7th/cmp-nvim-lsp-document-symbol" },
            {
                "saadparwaiz1/cmp_luasnip",
                dependencies = {
                    {
                        "L3MON4D3/LuaSnip",
                        dependencies = {
                            "rafamadriz/friendly-snippets",
                        },
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    },
                },
            },
            { "onsails/lspkind.nvim" },
            -- { "zbirenbaum/copilot-cmp" },
            -- { "windwp/nvim-autopairs" },
        },
        config = function()
            local cmp = require("cmp")


            cmp.setup({
                preselect = cmp.PreselectMode.None,
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
                        local function has_words_before()
                            if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
                                return false
                            end
                            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                            return col ~= 0 and
                                vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                        end

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

            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = 'cmp_git' },
                })
            })

            cmp.event:on("menu_opened", function()
                vim.b.copilot_suggestion_hidden = true
            end)
            cmp.event:on("menu_closed", function()
                vim.b.copilot_suggestion_hidden = false
            end)
            cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
        end
    },

    {
        "zbirenbaum/copilot.lua",
        enabled = false,
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
        enabled = false,
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
            require("copilot_cmp").setup()
        end,
    },
}
