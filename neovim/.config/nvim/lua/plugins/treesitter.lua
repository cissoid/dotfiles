return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        opts = {
            ensure_installed = {},
            auto_install = true,
            highlight = {
                enable = true,
                -- additional_vim_regex_highlighting = true,
            },
            incremental_selection = {
                enable = false,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                }
            },
            indent = {
                enable = true,
            }
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        event = { "BufReadPost", "BufNewFile" },
    },
}
