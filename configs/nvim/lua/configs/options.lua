local o = vim.o
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

o.encoding = "utf-8"
o.fileencoding = "utf-8"

o.nu = true
o.relativenumber = true
o.cursorline = true

o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true

o.smartindent = true

o.wrap = false

o.swapfile = false
o.backup = false
o.undodir = os.getenv "HOME" .. "/.vim/undodir"
o.undofile = true

o.hlsearch = true
o.incsearch = true

o.termguicolors = true

o.scrolloff = 8
o.signcolumn = "yes"
opt.isfname:append "@-@"

o.updatetime = 50

o.colorcolumn = "100"

opt.completeopt:append("noselect")

o.winborder = "rounded"
