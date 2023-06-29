return {
    {
        "tpope/vim-fugitive",
        cmd = "Git",
    },

    {
        "TimUntersberger/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        cmd = "Neogit",
        config = true,
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = true,
    },

    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "DiffviewOpen",
        opts = {
            view = {
                merge_tool = {
                    layout = "diff4_mixed"
                }
            }
        },
    },
}
