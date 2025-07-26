return {
    "stevearc/oil.nvim",
    -- lazy = false,
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
            show_hidden = true,
            natural_order = "fast",
            is_always_hidden = function(name, _)
                return name == ".." or name == ".git"
            end,
        },
        float = {
            padding = 2,
            max_width = 0.6,
            max_height = 0.5,
            win_options = {
                winblend = 0,
            },
        },
        keymaps = {
            ["<C-c>"] = { "actions.close", mode = "n" },
            ["q"] = "actions.close",
        },
    },
    keys = {
        {
            "-",
            "<CMD>Oil --float<CR>",
            mode = { "n", "v" },
            desc = "Open parent directory",
        },
    },
}
