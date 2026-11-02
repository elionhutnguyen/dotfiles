-- Global options
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.cursorline = true
opt.scrolloff = 8
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- Supermaven inline code completion setup
local has_supermaven, supermaven = pcall(require, "supermaven-nvim")
if has_supermaven then
  supermaven.setup({
    keymaps = {
      accept_suggestion = "<Tab>",
      clear_suggestion = "<C-]>",
      accept_word = "<C-j>",
    },
    ignore_filetypes = { "TelescopePrompt" },
    color = {
      suggestion_color = "#6c7086",
      cterm = 244,
    },
    disable_inline_completion = false,
    disable_keymaps = false,
  })
end
