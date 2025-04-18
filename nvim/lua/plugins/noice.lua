return {
    "folke/noice.nvim",
    opts = function(_, opts)
        opts.cmdline = {
            view = "cmdline",
        }
        opts.routes = {
            {
                filter = {
                    event = "lsp",
                    kind = "progress",
                    find = "jdtls",
                },
                opts = { skip = true },
                view = "mini",
            },
            {
                filter = {
                    event = "msg_show",
                    any = {
                        { find = "%d+L, %d+B" },
                        { find = "; after #%d+" },
                        { find = "; before #%d+" },
                    },
                },
                view = "mini",
            },
        }
    end,
}
