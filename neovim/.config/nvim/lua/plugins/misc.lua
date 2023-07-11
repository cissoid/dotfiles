return {
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
        "toppair/peek.nvim",
        enabled = false,
        build = "deno task --quiet build:fast",
        cmd = "PeekToggle",
        config = function()
            require("peek").setup({})

            vim.api.nvim_create_user_command("PeekToggle", function()
                local peek = require("peek")
                if peek.is_open() then
                    peek.close()
                else
                    peek.open()
                end
            end, {})
        end,
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
}
