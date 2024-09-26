return {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
        opts.config.center = {
            {
                action = "lua LazyVim.pick()()",
                desc = " Find file",
                icon = " ",
                key = "f",
                key_format = " %s",
            },
            {
                action = "ene | startinsert",
                desc = " New file",
                icon = " ",
                key = "n",
                key_format = " %s",
            },
            {
                action = 'lua LazyVim.pick("oldfiles")()',
                desc = " Recent files",
                icon = " ",
                key = "r",
                key_format = " %s",
            },
            {
                action = 'lua LazyVim.pick("live_grep")()',
                desc = " Find text",
                icon = " ",
                key = "g",
                key_format = " %s",
            },
            {
                action = "lua LazyVim.pick.config_files()()",
                desc = " Config",
                icon = " ",
                key = "c",
                key_format = " %s",
            },
            {
                action = "LazyExtras",
                desc = " Lazy Extras",
                icon = " ",
                key = "x",
                key_format = " %s",
            },
            {
                action = "Lazy",
                desc = " Lazy",
                icon = "󰒲 ",
                key = "l",
                key_format = " %s",
            },
            {
                action = function()
                    vim.api.nvim_input("<cmd>qa<cr>")
                end,
                desc = " Quit",
                icon = " ",
                key = "q",
                key_format = " %s",
            },
        }
        local logo = [[
                                                                    
      ████ ██████           █████      ██                     
     ███████████             █████                             
     █████████ ███████████████████ ███   ███████████   
    █████████  ███    █████████████ █████ ██████████████   
   █████████ ██████████ █████████ █████ █████ ████ █████   
 ███████████ ███    ███ █████████ █████ █████ ████ █████  
██████  █████████████████████ ████ █████ █████ ████ ██████ 
]]

        logo = string.rep("\n", 8) .. logo .. "\n\n"
        opts.config.header = vim.split(logo, "\n")
    end,
}
