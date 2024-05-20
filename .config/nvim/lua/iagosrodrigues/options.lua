-- vim.o.guicursor = "n-v-c:block-Cursor"
-- vim.o.guicursor = ""
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"

vim.o.nu = true
vim.o.relativenumber = true
vim.o.cursorline = false

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.smartindent = true

vim.o.wrap = false

vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

vim.o.hlsearch = true
vim.o.incsearch = true

vim.o.termguicolors = true

vim.o.scrolloff = 8
vim.o.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- vim.o.list = true
-- vim.opt.listchars:append("eol:↲")
-- vim.opt.listchars = {
--     -- tab = "  ",
--     -- eol = "↲",
--     -- nbsp = "␣",
--     -- trail = "•",
--     -- extends = "⟩",
--     -- precedes = "⟨",
-- }

vim.o.updatetime = 50

vim.o.colorcolumn = "100"

vim.g.mapleader = " "

-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldenable = false

-- Netrw {{{
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
-- }}}

if vim.g.neovide then
	vim.g.neovide_input_use_logo = 1
	vim.g.neovide_input_macos_alt_is_meta = false
	vim.o.guifont = "MonoLisa Nerd Font:h20"
	vim.opt.linespace = 2
	vim.g.neovide_padding_top = 20
	vim.g.neovide_padding_bottom = 20
	vim.g.neovide_padding_right = 20
	vim.g.neovide_padding_left = 20
	vim.g.neovide_refresh_rate = 60
end
