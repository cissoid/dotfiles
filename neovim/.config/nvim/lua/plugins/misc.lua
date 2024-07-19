return {
    {
        "danymat/neogen",
        version = "*",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        cmd = "Neogen",
        opts = {
            ---
            languages = {
                python = { template = { annotation_convention = "reST" } }
            }
        },
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
        "yorickpeterse/nvim-window", -- quick window jump
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
        "sindrets/winshift.nvim",
        cmd = "WinShift",
        opts = {},
    },
}
