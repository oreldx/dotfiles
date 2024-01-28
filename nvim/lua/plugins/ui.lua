return {
    {
        "folke/noice.nvim",
        opts = function(_, opts)
            table.insert(opts.routes, {
                filter = {
                    event = "notify",
                    find = "No information available",
                },
                opts = { skip = true },
            })
            table.insert(opts.routes, {
                filter = {
                    event = "notify",
                    find = "Plugin Updates",
                },
                opts = { skip = true },
            })
        end,
    },
    -- buffer line
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        keys = {
            { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
            { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
        },
    },
    -- logo
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        opts = function(_, opts)
            local logo = [[
 ██████╗ ██████╗ ███████╗██╗     
██╔═══██╗██╔══██╗██╔════╝██║     
██║   ██║██████╔╝█████╗  ██║     
██║   ██║██╔══██╗██╔══╝  ██║     
╚██████╔╝██║  ██║███████╗███████╗
 ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝
        ]]

            logo = string.rep("\n", 8) .. logo .. "\n\n"
            opts.config.header = vim.split(logo, "\n")
        end,
    },
    -- animations
    {
        "echasnovski/mini.animate",
        event = "VeryLazy",
        opts = function(_, opts)
            opts.scroll = {
                enable = false,
            }
        end,
    },
}
