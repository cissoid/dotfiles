return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            {
                "mfussenegger/nvim-dap",
                config = function()
                    local dap = require("dap");

                    dap.adapters.python = {
                        type = "executable",
                        command = "debugpy-adapter",
                    }
                    dap.configurations.python = {
                        {
                            type = "python",
                            request = "launch",
                            name = "Launch file",
                            program = "${file}",
                            pythonPath = function() return "python" end,
                        }
                    }
                end
            }
        },
        keys = {
            { "<Leader>d<Space>", function() return require("dapui").toggle() end, silent = true, desc = "dap ui toggle" },
        },
        config = true,
    },
}
