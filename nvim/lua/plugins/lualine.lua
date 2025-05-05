return {
    "nvim-lualine/lualine.nvim",
    opts = {
        sections = {
            lualine_x = {
                {
                    function()
                        return "  " .. require("dap").status()
                    end,
                    cond = function()
                        return package.loaded["dap"] and require("dap").status() ~= ""
                    end,
                    color = function()
                        return { fg = Snacks.util.color("Debug") }
                    end,
                },
                {
                    "diff",
                    symbols = {
                        added = " ",
                        modified = " ",
                        removed = " ",
                    },
                    source = function()
                        local gitsigns = vim.b.gitsigns_status_dict
                        if gitsigns then
                            return {
                                added = gitsigns.added,
                                modified = gitsigns.changed,
                                removed = gitsigns.removed,
                            }
                        end
                    end,
                },
            },
            lualine_z = {},
        },
    },
}
