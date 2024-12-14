 set relativenumber
set number
set mouse=a
set clipboard=unnamedplus
set virtualedit=all 
 lua << EOF

-- space as the leader key

vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })

vim.g.mapleader = " "

vim.g.maplocalleader = " "

vim.api.nvim_set_keymap("n", "q", ":qa!<cr>", {})
