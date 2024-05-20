vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>fe", "<cmd>Oil<CR>")

vim.keymap.set({ "n", "v", "i" }, "<Up>", "<nop>")
vim.keymap.set({ "n", "v", "i" }, "<Down>", "<nop>")
vim.keymap.set({ "n", "v", "i" }, "<Left>", "<nop>")
vim.keymap.set({ "n", "v", "i" }, "<Right>", "<nop>")

vim.keymap.set({ "n", "v", "i" }, "<S-Up>", "<nop>")
vim.keymap.set({ "n", "v", "i" }, "<S-Down>", "<nop>")
vim.keymap.set({ "n", "v", "i" }, "<S-Left>", "<nop>")
vim.keymap.set({ "n", "v", "i" }, "<S-Right>", "<nop>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
-- vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

vim.keymap.set("v", "Q", "<nop>")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>go", '<cmd>silent !tmux send-keys -t "{right}" C-c "go run ./cmd" C-m<CR>')

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<leader>nf", "<cmd>lua require('neogen').generate({ type = 'func' })<CR>")
vim.keymap.set("n", "<leader>nc", "<cmd>lua require('neogen').generate({ type = 'class' })<CR>")
vim.keymap.set("n", "<leader>nt", "<cmd>lua require('neogen').generate({ type = 'type' })<CR>")

if vim.g.neovide then
	vim.keymap.set("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
	vim.keymap.set("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
	vim.keymap.set("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
	vim.keymap.set("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
end
