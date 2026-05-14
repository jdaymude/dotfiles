return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        -- See :help lspconfig-all for a complete list.
        ensure_installed = {
            "clangd",          -- C/C++
            "gopls",           -- Go
            "lua_ls",          -- Lua
            "markdown_oxide",  -- Markdown (Obsidian-like)
            "ruff",            -- Python (linting and formatting)
            "rust_analyzer",   -- Rust
            "texlab",          -- LaTeX
            "ty",              -- Python (type checking)
        },
    },
    dependencies = {
        {
            "mason-org/mason.nvim",
            opts = {},
        },
        "neovim/nvim-lspconfig",
    },
}
