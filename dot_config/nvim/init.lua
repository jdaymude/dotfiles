-- Disable netrw, as suggested by nvim-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Remap leader keys before loading lazy.nvim.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Enable 24-bit color.
vim.opt.termguicolors = true

-- Show line numbers.
vim.opt.number = true

-- Show a vertical ruler at 80 characters.
vim.opt.colorcolumn = "80"

-- Set auto-indentation to 4 spaces.
vim.opt.expandtab = true
vim.opt.shiftwidth = 0
vim.opt.tabstop = 4

-- Allow editing where there is no text in visual mode.
vim.opt.virtualedit = "block"

-- Put new splits after the current one instead of before.
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Ignore case when searching except when search has capitals.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Hide the bottom line's vim mode; redundant with lualine.
vim.opt.showmode = false

-- Don't save blank windows as sessions.
vim.opt.sessionoptions:remove("blank")

-- Load all plugins using lazy.nvim.
require("config.lazy")

-- Load my LSP configurations.
require("config.lsp")

-- Color scheme.
vim.cmd.colorscheme "catppuccin-nvim"
