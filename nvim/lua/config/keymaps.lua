-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("v", "J", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "K", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "x", "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set({ "x", "n", "v" }, "<leader>x", [["_x]])

vim.keymap.set({ "i", "x", "n", "v" }, "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
