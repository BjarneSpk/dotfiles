-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
vim.keymap.set("n", "<leader><cr>", "a<CR><Esc>")

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

-- change [] to öä
local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

vim.keymap.del({ "i", "x", "n", "v" }, "<C-s>")

vim.keymap.del("n", "]q")
vim.keymap.del("n", "[q")

vim.keymap.del("n", "[d")
vim.keymap.del("n", "]d")
vim.keymap.del("n", "[e")
vim.keymap.del("n", "]e")
vim.keymap.del("n", "[w")
vim.keymap.del("n", "]w")

vim.keymap.del("n", "<leader><tab>[")
vim.keymap.del("n", "<leader><tab>]")

vim.keymap.set("n", "öq", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "äq", vim.cmd.cnext, { desc = "Next Quickfix" })

vim.keymap.set("n", "äd", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "öd", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "äe", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "öe", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "äw", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "öw", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

vim.keymap.set("n", "<leader><tab>ä", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>ö", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
