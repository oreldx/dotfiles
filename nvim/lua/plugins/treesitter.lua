return {
    { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "css",
                "fish",
                "gitignore",
                "graphql",
                "http",
                "java",
                "php",
                "rust",
                "scss",
                "sql",
                "svelte",
                "python",
            },
        },
    },
}
