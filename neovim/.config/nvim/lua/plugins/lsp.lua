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
        "jose-elias-alvarez/null-ls.nvim",
        event = "VeryLazy",
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
        end,
    },

    {
        "weilbith/nvim-code-action-menu",
        cmd = "CodeActionMenu",
        config = true,
    },

    {
        "kosayoda/nvim-lightbulb",
        event = "LspAttach",
        opts = {
            autocmd = {
                enable = true,
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

            symbol_in_winbar = {
                enable = false
            }
        },
    },
}
