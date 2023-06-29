return {
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
        "danymat/neogen",
        version = "*",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        cmd = "Neogen",
        config = true,
    },

    {
        "ellisonleao/glow.nvim",
        ft = "markdown",
        cmd = "Glow",
        config = true,
    },

    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        init = function()
            vim.g.startuptime_tries = 10
        end
    },

    {
        "https://gitlab.com/yorickpeterse/nvim-window.git", -- quick window jump
        keys = {
            { "<Leader>w", function() require("nvim-window").pick() end, silent = true, desc = "quick window jump" },
        },
        opts = {
            chars = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n" },
            normal_hl = "Normal",
            hint_hl = "Bold",
            border = "single"
        },
    },

    {
        "jinh0/eyeliner.nvim",
        event = "VeryLazy",
        opts = {
            highlight_on_key = true,
            dim = true,
        },
    },
}
