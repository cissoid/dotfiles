return {
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
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
        cmd = "Mason",
        build = ":MasonUpdate",
        config = true,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "RRethy/vim-illuminate",
            "nanotee/nvim-lsp-basics",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
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

            require("mason-lspconfig").setup({
                automatic_installation = true,
                handlers = {
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
                                        hints = {
                                            assignVariableTypes = true,
                                            compositeLiteralFields = true,
                                            compositeLiteralTypes = true,
                                            constantValues = true,
                                            functionTypeParameters = true,
                                            parameterNames = true,
                                            rangeVariableTypes = true,
                                        },
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
                    end,
                },
            })
        end
    },

    {
        -- lsp progress bar
        "j-hui/fidget.nvim",
        enabled = false,
        event = "VeryLazy",
        branch = "legacy",
        config = function()
            require("fidget").setup({
                text = {
                    spinner = "dots",
                },
            })
        end
    },

    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                on_init = function(new_client, _)
                    new_client.offset_encoding = 'utf-16'
                end,
                sources = {
                    -- common
                    null_ls.builtins.code_actions.cspell,
                    null_ls.builtins.code_actions.refactoring,
                    null_ls.builtins.code_actions.shellcheck,
                    -- python
                    null_ls.builtins.diagnostics.ruff.with({
                        extra_args = { "--config", "~/.config/ruff.toml" },
                    }),
                    null_ls.builtins.diagnostics.flake8.with({
                        extra_args = { "--config", "~/.config/flake8" },
                    }),
                    null_ls.builtins.diagnostics.pylint,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.black.with({
                        extra_args = { "--line-length", "120" },
                    }),
                    -- go
                    null_ls.builtins.diagnostics.golangci_lint,
                    null_ls.builtins.diagnostics.revive,
                    null_ls.builtins.diagnostics.staticcheck,
                    null_ls.builtins.formatting.gofumpt,
                    null_ls.builtins.formatting.goimports,
                    -- lua
                    -- null_ls.builtins.formatting.stylua,
                    -- protobuf
                    null_ls.builtins.diagnostics.buf,
                    null_ls.builtins.diagnostics.protoc_gen_lint,
                    null_ls.builtins.diagnostics.protolint,
                    -- sql
                    null_ls.builtins.diagnostics.sqlfluff,
                    -- json
                    null_ls.builtins.formatting.prettier,
                    -- fish
                    null_ls.builtins.diagnostics.fish,
                },
            })
        end,
    },

    -- {
    --     "jay-babu/mason-null-ls.nvim",
    --     event = "VeryLazy",
    --     dependencies = {
    --         { "williamboman/mason.nvim" },
    --         { "jose-elias-alvarez/null-ls.nvim" },
    --     },
    --     opts = {
    --         automatic_installation = false,
    --     },
    -- },

    {
        "kosayoda/nvim-lightbulb",
        enabled = false,
        event = "LspAttach",
        opts = {
            finder = {
                layout = "normal",
            },
            callhierarchy = {
                layout = "normal",
            },
            sign = {
                enabled = true,
            },
            autocmd = {
                enabled = true,
            },
        },
    },

    {
        "glepnir/lspsaga.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-treesitter/nvim-treesitter",
        },
        event = "LspAttach",
        opts = {
            lightbulb = {
                enable = false,
            },
            symbol_in_winbar = {
                enable = false
            }
        },
    },
}
