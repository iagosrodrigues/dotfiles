local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search" })
map("n", ";", ":", { desc = "CMD enter command mode" })

map({ "n", "v", "i" }, "<Up>", "<nop>")
map({ "n", "v", "i" }, "<Down>", "<nop>")
map({ "n", "v", "i" }, "<Left>", "<nop>")
map({ "n", "v", "i" }, "<Right>", "<nop>")

map({ "n", "v", "i" }, "<S-Up>", "<nop>")
map({ "n", "v", "i" }, "<S-Down>", "<nop>")
map({ "n", "v", "i" }, "<S-Left>", "<nop>")
map({ "n", "v", "i" }, "<S-Right>", "<nop>")

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '>-2<CR>gv=gv")

map("n", "Y", "yg$")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("x", "<leader>p", '"_dP')

map("n", "<leader>y", '"+y')
map("v", "<leader>y", '"+y')
map("n", "<leader>Y", '"+Y')

map("n", "<leader>d", '"_d')
map("v", "<leader>d", '"_d')

map("v", "Q", "<nop>")

-- map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- map("n", "<leader>go", '<cmd>silent !tmux send-keys -t "{right}" C-c "go run ./cmd" C-m<CR>')

map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")
