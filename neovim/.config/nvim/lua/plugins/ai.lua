return {
    {
        "folke/sidekick.nvim",
        event = "VeryLazy",
        opts = {
            nes = {
                enabled = false
            },
            cli = {
                win = {
                    keys = {
                        hide_n = false,
                        hide_ctrl_dot = false,
                        hide_ctrl_z = false,
                        prompt = false,
                    },
                },
                mux = {
                    enabled = false,
                    backend = "tmux",
                },
                tools = {
                    codebuddy = {
                        cmd = {"codebuddy-code"},
                    }
                }
            }
        },
        keys = {
            {
                "<leader>at",
                function() require("sidekick.cli").toggle() end,
                desc='sidekick cli toggle',
            }
        }
    }
}

