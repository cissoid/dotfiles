return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",

            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build =
                "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
        },
        keys = {
            {
                "<Leader>ft",
                function() require("telescope.builtin").builtin() end,
                silent = true,
                desc = "telescope",
            },
            {
                "<Leader>ff",
                function() require("telescope.builtin").find_files() end,
                silent = true,
                desc = "telescope find_files",
            },
            {
                "<Leader>fg",
                function() require("telescope.builtin").live_grep() end,
                silent = true,
                desc = "telescope live_grep",
            },
            {
                "<Leader>fb",
                function() require("telescope.builtin").buffers() end,
                silent = true,
                desc = "telescope buffers",
            },
            {
                "<Leader>fr",
                function() require("telescope.builtin").resume() end,
                silent = true,
                desc = "telescope resume",
            },
            {
                "<Leader>fi",
                function() require("telescope.builtin").lsp_incoming_calls() end,
                silent = true,
                desc = "telescope lsp_incoming_calls",
            },
            {
                "<Leader>fo",
                function() require("telescope.builtin").lsp_outgoing_calls() end,
                silent = true,
                desc = "telescope lsp_outgoing_calls",
            },
        },
        cmd = "Telescope",
        opts = {
            defaults = {
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                    }
                },
                winblend = 0,
                results_title = false,
                dynamic_preview_title = true,
            }
        },
    },

    {
        "AckslD/nvim-neoclip.lua",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        keys = {
            {
                "<Leader>fy",
                "<Cmd>Telescope neoclip<CR>",
                silent = true,
                desc = "telescope neoclip",
            },
        },
        config = function()
            require("telescope").load_extension("neoclip")
        end
    },

    {
        "sudormrfbin/cheatsheet.nvim",
        dependencies = {
            { 'nvim-telescope/telescope.nvim' },
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' },
        },
        cmd = "Cheatsheet",
    },

    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("refactoring").setup()

            require("telescope").load_extension("refactoring")
        end,
    }
}
