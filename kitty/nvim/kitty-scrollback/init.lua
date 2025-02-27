-- kitty-scrollback-nvim-kitten-config.lua

-- put your general Neovim configurations here
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set({ "n", "v" }, "y", '"+y', {})

-- add kitty-scrollback.nvim to the runtimepath to allow us to require the kitty-scrollback module
-- pick a runtimepath that corresponds with your package manager, if you are not sure leave them all it will not cause any issues
-- vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/kitty-scrollback.nvim') -- lazy.nvim
-- require('kitty-scrollback').setup({
--   -- put your kitty-scrollback.nvim configurations here
-- })
