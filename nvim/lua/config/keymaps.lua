-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Block Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Block Up" })

vim.keymap.set("n", "<leader>o", "mzo<Esc>`z")
vim.keymap.set("n", "<leader>O", "mzO<Esc>`z")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "x", "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set({ "x", "n", "v" }, "<leader>x", [["_x]])

vim.keymap.set({ "i", "x", "n", "v" }, "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>/", "<C-W>v", { desc = "Split Window Right", remap = true })
