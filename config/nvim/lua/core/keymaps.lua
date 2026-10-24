local map = vim.keymap.set

-- Buffer navigation
map("n", "<Tab>", ":bnext<CR>", { silent = true })
map("n", "<S-Tab>", ":bprevious<CR>", { silent = true })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer", silent = true })

-- Window splits
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
map("n", "<C-h>", "<C-w>h", { silent = true })
map("n", "<C-j>", "<C-w>j", { silent = true })
map("n", "<C-k>", "<C-w>k", { silent = true })
map("n", "<C-l>", "<C-w>l", { silent = true })

-- Fast file actions
map("n", "<leader>w", ":w<CR>", { desc = "Save file", silent = true })
map("n", "<leader>q", ":q<CR>", { desc = "Quit", silent = true })

-- Stay in indent mode when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
