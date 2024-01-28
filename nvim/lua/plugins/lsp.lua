return {
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, {
                "stylua",
                "tailwindcss-language-server",
                "docker-compose-language-service",
                "dockerfile-language-server",
                "markdownlint",
                "pyright",
                "css-lsp",
            })
        end,
    },
}
