return {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
        "esmuellert/codediff.nvim",      -- View diffs.
        "nvim-telescope/telescope.nvim", -- Fuzzy finds.
    },
    cmd = "Neogit",
    keys = {
        {
            "<leader>gg",
            "<cmd>Neogit<cr>",
            desc = "Show Neogit UI",
        },
    },
}
