-- List all installed LSPs. Ideally, this would be read automatically from
-- mason-lspconfig's opts.ensure_installed, but I don't know how to do that.
local lsps = {
    "clangd",          -- C/C++
    "gopls",           -- Go
    "lua_ls",          -- Lua
    "markdown_oxide",  -- Markdown (Obsidian-like)
    "ruff",            -- Python (linting and formatting)
    "rust_analyzer",   -- Rust
    "texlab",          -- LaTeX
    "ty",              -- Python (type checking)
}

-- Specify LSP-specific options and settings.
local lsp_opts = {
    -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
    -- https://luals.github.io/wiki/settings/
    ["lua_ls"] = function (opts)
        opts.settings = {
            Lua = {
                -- Tell the LSP to find Lua modules the same way Neovim does.
                runtime = {
                    version = "LuaJIT",
                    path = {
                        "lua/?.lua",
                        "lua/?/init.lua",
                    },
                },
                -- Declare `vim` as a global (to recognize vim.*).
                diagnostics = {
                    globals = { "vim" },
                },
                -- Tell the LSP about Neovim's runtime files.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                workspace = {
                    checkThirdParty = false,
                    library = vim.tbl_filter(function(d)
                        return not d:match(vim.fn.stdpath("config") .. "/?a?f?t?e?r?")
                    end, vim.api.nvim_get_runtime_file("", true)),
                },
            }
        }
    end,
    -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/texlab.lua
    -- https://github.com/latex-lsp/texlab/wiki/Configuration
    -- ["texlab"] = function (opts)
    --     opts.settings = {
    --         texlab = {
    --             chktex = {
    --                 onOpenAndSave = true,
    --                 onEdit = true,
    --             },
    --         },
    --     }
    -- end,
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, lsp in pairs(lsps) do
    -- Advertise nvim-cmp completion capabilities to each LSP.
    local opts = {
        capabilities = capabilities,
        update_in_insert = true,
    }

    -- If I specified LSP-specific settings above, set them here.
    if lsp_opts[lsp] then
        lsp_opts[lsp](opts)
    end

    -- Pass the complete set of customized options to nvim-lspconfig.
    vim.lsp.config(lsp, opts)
end
