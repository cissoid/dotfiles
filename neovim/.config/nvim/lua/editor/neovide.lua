if vim.g.neovide ~= nil then
    vim.opt.guifont = "Monaco,Symbols Nerd Font Mono:h14"
    vim.g.neovide_remember_window_size = true
    vim.g.neovide_input_macos_option_key_is_meta = true
    vim.g.neovide_input_ime = true

    vim.g.neovide_input_use_logo = 1
    vim.api.nvim_set_keymap("", "<D-c>", "+y<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("!", "<D-c>", "+y<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("v", "<D-c>", "+y<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("t", "<D-c>", "+y<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
end
