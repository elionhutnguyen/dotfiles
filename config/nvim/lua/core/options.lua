local opt = vim.opt

-- Appearance
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8

-- Tabs & Indents
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search (Optimized for ripgrep)
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Performance & Undo
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.updatetime = 200

-- Native Wayland Clipboard (hooks directly into wl-clipboard)
opt.clipboard = "unnamedplus"
