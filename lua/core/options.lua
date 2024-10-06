vim.wo.number = true
vim.o.relativenumber = true
vim.o.clipboard = 'unnamedplus'
vim.o.wrap = false
vim.o.linebreak = true
vim.o.mouse = 'a'
vim.o.autoindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitbelow = true -- Force all horizontal splits to go below current window (default: false)
vim.o.splitright = true -- Force all vertical splits to go to the right of current window (default: false)
vim.opt.termguicolors = true
vim.o.fileencoding = 'utf-8'
vim.o.breakindent = true
vim.opt.formatoptions:remove { 'c', 'r', 'o' }
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.scrolloff = 4
vim.g.lazyvim_php_lsp = "intelephense"