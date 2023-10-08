return {
    {
        "kylechui/nvim-surround",
        event = { "BufReadPost", "BufNewFile" },
        config = true,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = { check_ts = true },
    },

    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = true,
    },

    {
        "phaazon/hop.nvim",
        enabled = false,
        keys = {
            {
                "<Leader><Leader>s",
                function() return require("hop").hint_patterns() end,
                silent = true,
                desc = "easy motion",
            },
        },
        config = true,
    },

    {
        "folke/flash.nvim",
        -- event = "VeryLazy",
        keys = {
            { "s",     function() require("flash").jump() end,   mode = { "n", "x", "o" } },
            -- { "S",     function() require("flash").treesitter() end, mode = { "n", "x", "o" } },
            -- { "r",     function() require("flash").remote() end,            mode = { "o" } },
            -- { "R",     function() require("flash").treesitter_search() end, mode = { "o", "x" } },
            { "<C-s>", function() require("flash").toggle() end, mode = { "c" } },
        },
        opts = {
            label = {
                style = "overlay",
            },
            modes = {
                search = {
                    enabled = false,
                },
                char = {
                    jump_labels = true,
                },
            },
        },
    },

    {
        "monaqa/dial.nvim",
        keys = {
            {
                "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment"
            },
            {
                "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement"
            },
        },
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                default = {
                    augend.constant.new({ elements = { "True", "False", } }),
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.date.alias["%Y/%m/%d"],
                    augend.date.alias["%Y-%m-%d"],
                    augend.constant.alias.bool,
                    augend.constant.alias.alpha,
                    augend.constant.alias.Alpha,
                    augend.constant.alias.semver,
                }
            })
        end,
    }
}
