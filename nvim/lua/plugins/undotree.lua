return {
    { "debugloop/telescope-undo.nvim" },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>uu", "<cmd>Telescope undo<CR>", { desc = "Telescope Undo" } },
        },
    },
}
