return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        opts = {
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
