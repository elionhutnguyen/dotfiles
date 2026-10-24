require("lazy").setup({
  -- 1. Colorscheme (loaded immediately for UI render)
  {
    "catppuccin-nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- 2. Statusline (deferred to 'VeryLazy' so it won't delay startup)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "catppuccin-nvim",
        globalstatus = true, -- Clean modern single statusline across all splits
      },
    },
  },

  -- 3. Syntax Highlighting (migrated to new 'main' branch)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- Treesitter queries must be ready on launch
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      -- Automated background parser installation
      ts.install({
        -- Your requested languages:
        "nix",
        "lua",
        "bash",
        "markdown",
        "markdown_inline",
        "toml",
        "json",
        -- Essential for Neovim internals & docs:
        "vim",
        "vimdoc",
      })

      -- High-efficiency Treesitter activation via native Neovim API
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Enable Tree-sitter highlighting and indentation",
        callback = function(args)
          -- pcall safely ignores filetypes that lack an installed grammar
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Optional: Fast AST-aware code folding (folds start open)
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldenable = false
    end,
  },

  -- 4. Fuzzy Search (lazy-loaded strictly on command or keypress)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
    opts = {
      defaults = {
        path_display = { "truncate" },
      },
    },
  },
}, {
  -- =========================================================================
  -- Performance & Efficiency Settings
  -- =========================================================================
  checker = {
    -- FIXES THE 5.2s FREEZE: Disables blocking GitHub checks on launch.
    -- You can still manually update whenever you want by running :Lazy update
    enabled = false,
  },
  change_detection = {
    notify = false, -- Don't show popups every time you save config files
  },
  performance = {
    rtp = {
      -- Disable built-in Vim plugins that you don't use to save startup time
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
