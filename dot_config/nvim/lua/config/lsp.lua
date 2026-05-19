-- List all installed LSPs. Ideally, this would be read automatically from
-- mason-lspconfig's opts.ensure_installed, but I don't know how to do that.
local lsps = {
    "clangd",         -- C/C++
    "gopls",          -- Go
    "lua_ls",         -- Lua
    "markdown_oxide", -- Markdown (Obsidian-like)
    "ruff",           -- Python (linting and formatting)
    "rust_analyzer",  -- Rust
    "texlab",         -- LaTeX
    "ty",             -- Python (type checking)
}

-- Specify LSP-specific options and settings.
local lsp_opts = {
    -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
    -- https://luals.github.io/wiki/settings/
    ["lua_ls"] = function(opts)
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
                -- Tell the LSP about Neovim's runtime files (ignoring self).
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
    ["texlab"] = function(opts)
        opts.settings = {
            texlab = {
                -- I prefer to define how my LaTeX documents are built, often
                -- because I'm doing some funny business with compiling things
                -- multiple times (e.g., presenter vs. handout beamer slides)
                -- or combining documents (e.g., proposals).
                build = {
                    executable = "make",
                    args = { "-C", vim.fn.getcwd() },
                    onSave = true,
                    forwardSearchAfter = true,
                },
                -- Preview documents with okular.
                -- https://github.com/latex-lsp/texlab/wiki/Previewing#okular
                forwardSearch = {
                    executable = "okular",
                    args = { "--unique", "file:%p#src:%l%f" },
                },
                -- Use chktex to lint on open/save, but not while editing.
                chktex = {
                    onOpenAndSave = true,
                    onEdit = false,
                },
                -- Point latexindent to my custom formatting settings.
                latexFormatter = "latexindent",
                latexindent = {
                    ["local"] = "${HOME}/.config/latexindent/settings",
                    modifyLineBreaks = true,
                },
                -- Do not set a maximum line length in BibTeX files.
                formatterLineLength = 0,
            },
        }
    end,
}

-- Get nvim-cmp completion capabilities to advertise to LSPs.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Define common keymaps for buffer-local, LSP-based functionality.
-- https://stephenvantran.com/posts/2025-10-29-setup-neovim-lsp-011
local common_on_attach = function(client, bufnr)
    local map = function(modes, lhs, rhs, desc)
        vim.keymap.set(modes, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gr", vim.lsp.buf.references, "Go to references")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "H", vim.lsp.buf.hover, "Hover")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>e", vim.diagnostic.open_float, "Line diagnostics")

    -- Show inlay hints.
    if vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Format on save (if the LSP provides a formatter).
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = true })
            end,
        })
    end
end

-- Put it all together.
for _, lsp in pairs(lsps) do
    -- Define options common to all LSPs.
    local opts = {
        on_attach = {
            existing = (vim.lsp.config[lsp] or {}).on_attach,
            common = common_on_attach,
        },
        capabilities = capabilities,
        update_in_insert = true,
    }

    -- Set LSP-specific settings, if I defined them above.
    if lsp_opts[lsp] then
        lsp_opts[lsp](opts)
    end

    -- Pass the complete set of customized options to nvim-lspconfig.
    vim.lsp.config(lsp, opts)
end
