# modules/hm/neovim.nix
# Vertical Module: Neovim editor (100% self-contained local options)
_: {
  den.default.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.neovim;
    in
    {
      options.my.neovim = {
        enable = lib.mkEnableOption "Kickstart-inspired declarative Neovim";

        colorscheme = lib.mkOption {
          type = lib.types.str;
          default = "tokyonight";
          description = "Neovim colorscheme name.";
        };

        extraPlugins = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Additional Neovim plugins to install alongside the core suite.";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.neovim = {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;

          withPython3 = false;

          extraPackages = with pkgs; [
            nixd
            nixfmt

            lua-language-server
            stylua

            bash-language-server
            shellcheck
            shfmt

            marksman
            taplo
            yaml-language-server
            vscode-langservers-extracted
          ];

          plugins =
            (with pkgs.vimPlugins; [
              tokyonight-nvim
              nvim-web-devicons
              (nvim-treesitter.withPlugins (
                p: with p; [
                  bash
                  diff
                  git_config
                  git_rebase
                  gitcommit
                  gitignore
                  json
                  lua
                  luadoc
                  markdown
                  markdown_inline
                  nix
                  python
                  query
                  regex
                  toml
                  vim
                  vimdoc
                  yaml
                ]
              ))
              oil-nvim
              plenary-nvim
              telescope-nvim
              telescope-fzf-native-nvim
              telescope-ui-select-nvim
              nvim-lspconfig
              blink-cmp
              conform-nvim
              gitsigns-nvim
              which-key-nvim
              mini-nvim
              markdown-preview-nvim
            ])
            ++ cfg.extraPlugins;

          initLua = ''
            -- =============================================================
            -- 0. Leader & Provider Hardening
            -- =============================================================
            vim.g.mapleader = " "
            vim.g.maplocalleader = " "

            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.g.loaded_perl_provider = 0
            vim.g.loaded_ruby_provider = 0
            vim.g.loaded_node_provider = 0
            vim.g.loaded_python3_provider = 0

            if vim.loader then
              vim.loader.enable()
            end

            -- =============================================================
            -- 1. Core Editor Options (Kickstart Baseline)
            -- =============================================================
            local opt = vim.opt
            opt.number = true
            opt.relativenumber = true
            opt.mouse = "a"
            opt.showmode = false
            opt.clipboard = "unnamedplus"
            opt.breakindent = true
            opt.undofile = true
            opt.ignorecase = true
            opt.smartcase = true
            opt.signcolumn = "yes"
            opt.updatetime = 250
            opt.timeoutlen = 300
            opt.splitright = true
            opt.splitbelow = true
            opt.list = true
            opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
            opt.inccommand = "split"
            opt.cursorline = true
            opt.scrolloff = 10
            opt.hlsearch = true
            opt.expandtab = true
            opt.shiftwidth = 2
            opt.tabstop = 2
            opt.termguicolors = true

            -- =============================================================
            -- 2. Core Keymaps & Autocommands
            -- =============================================================
            local map = vim.keymap.set
            map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
            map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
            map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

            map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to left window" })
            map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to right window" })
            map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to lower window" })
            map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to upper window" })

            vim.api.nvim_create_autocmd("TextYankPost", {
              group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
              callback = function()
                vim.highlight.on_yank()
              end,
            })

            -- =============================================================
            -- 3. Colorscheme
            -- =============================================================
            local ok_tn, tokyonight = pcall(require, "tokyonight")
            if ok_tn then
              tokyonight.setup({
                style = "moon",
                light_style = "day",
                day_brightness = 0.3,
              })
            end
            vim.cmd.colorscheme("${cfg.colorscheme}")

            -- =============================================================
            -- 4. Mini.nvim Modules (Textobjects, Surround, Statusline)
            -- =============================================================
            require("mini.ai").setup({ n_lines = 500 })
            require("mini.surround").setup()
            local statusline = require("mini.statusline")
            statusline.setup({ use_icons = true })
            statusline.section_location = function()
              return "%2l:%-2v"
            end

            -- =============================================================
            -- 5. Which-Key & Gitsigns
            -- =============================================================
            require("which-key").setup({
              spec = {
                { "<leader>s", group = "[S]earch" },
                { "<leader>c", group = "[C]ode" },
                { "<leader>m", group = "[M]arkdown" },
                { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
              },
            })

            require("gitsigns").setup({
              signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
              },
            })

            -- =============================================================
            -- 6. Oil.nvim (Filesystem as a Buffer)
            -- =============================================================
            require("oil").setup({
              default_file_explorer = true,
              delete_to_trash = true,
              skip_confirm_for_simple_edits = true,
              view_options = {
                show_hidden = true,
              },
            })
            map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory in Oil" })

            -- =============================================================
            -- 7. Telescope (Fuzzy Finder + Native C Sorter)
            -- =============================================================
            local telescope = require("telescope")
            telescope.setup({
              extensions = {
                ["ui-select"] = {
                  require("telescope.themes").get_dropdown(),
                },
              },
            })
            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "ui-select")

            local builtin = require("telescope.builtin")
            map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

            -- =============================================================
            -- 8. Completion (blink.cmp - Rust Fuzzy Engine)
            -- =============================================================
            require("blink.cmp").setup({
              keymap = { preset = "default" },
              appearance = { nerd_font_variant = "mono" },
              completion = { documentation = { auto_show = true } },
              sources = {
                default = { "lsp", "path", "snippets", "buffer" },
              },
              fuzzy = { implementation = "prefer_rust_with_warning" },
            })

            -- =============================================================
            -- 9. Formatting (conform.nvim)
            -- =============================================================
            require("conform").setup({
              notify_on_error = false,
              format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
              },
              formatters_by_ft = {
                nix = { "nixfmt" },
                lua = { "stylua" },
                python = { "ruff_format" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                zsh = { "shfmt" },
              },
            })
            map({ "n", "v" }, "<leader>cf", function()
              require("conform").format({ async = true, lsp_format = "fallback" })
            end, { desc = "[C]ode [F]ormat buffer" })

            -- =============================================================
            -- 10. Markdown Preview
            -- =============================================================
            map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "[M]arkdown [P]review Toggle" })

            -- =============================================================
            -- 11. Native LSP Configuration (Core + Dynamic devShell Support)
            -- =============================================================
            vim.api.nvim_create_autocmd("LspAttach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
              callback = function(event)
                local bmap = function(keys, func, desc, mode)
                  mode = mode or "n"
                  vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                bmap("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
                bmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
                bmap("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
                bmap("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
                bmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
                bmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                bmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
                bmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
              end,
            })

            local capabilities = require("blink.cmp").get_lsp_capabilities()

            local servers = {
              nixd = {
                bin = "nixd",
                settings = {
                  nixd = {
                    formatting = { command = { "nixfmt" } },
                  },
                },
              },
              lua_ls = {
                bin = "lua-language-server",
                settings = {
                  Lua = {
                    completion = { callSnippet = "Replace" },
                    diagnostics = { globals = { "vim" } },
                  },
                },
              },
              bashls = { bin = "bash-language-server" },
              marksman = { bin = "marksman" },
              taplo = { bin = "taplo" },
              yamlls = { bin = "yaml-language-server" },
              jsonls = { bin = "vscode-json-language-server" },
              basedpyright = { bin = "basedpyright-langserver" },
              ruff = { bin = "ruff" },
            }

            for server, s_cfg in pairs(servers) do
              if vim.fn.executable(s_cfg.bin) == 1 then
                local server_opts = {
                  capabilities = capabilities,
                  settings = s_cfg.settings or {},
                }
                if vim.lsp.config then
                  vim.lsp.config(server, server_opts)
                  vim.lsp.enable(server)
                else
                  require("lspconfig")[server].setup(server_opts)
                end
              end
            end
          '';
        };
      };
    };
}
