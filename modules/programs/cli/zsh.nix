# aspects/zsh.nix
{ ... }:
{
  den.aspects.zsh =
    { host, user }:
    {
      # ========================================================================
      # NixOS System Class: Shell Registration & System Completion Linking
      # ========================================================================
      nixos =
        { pkgs, ... }:
        {
          programs.zsh.enable = true;

          # Required so NixOS links /share/zsh/site-functions from system packages
          # into /run/current-system/sw/share/zsh for Home Manager's compinit.
          environment.pathsToLink = [ "/share/zsh" ];

          users.users.${user.userName}.shell = pkgs.zsh;
        };

      # ========================================================================
      # Home Manager User Class: Consolidated Shell, Plugins & Prompt Stack
      # ========================================================================
      homeManager =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          home.packages = [
            pkgs.zsh-completions
          ];

          programs = {
            # ------------------------------------------------------------------
            # 1. Core Zsh + Autosuggestions + Fast Syntax Highlighting + fzf-tab
            # ------------------------------------------------------------------
            zsh = {
              enable = true;
              enableCompletion = true;
              defaultKeymap = "emacs";

              autosuggestion = {
                enable = true;
                strategy = [
                  "history"
                  "completion"
                ];
              };

              # Use zdharma-continuum/fast-syntax-highlighting natively.
              # Keep `syntaxHighlighting.enable = false` to avoid dual ZLE hooks.
              fastSyntaxHighlighting.enable = true;
              syntaxHighlighting.enable = false;

              history = {
                size = 100000;
                save = 100000;
                extended = true;
                expireDuplicatesFirst = true;
                ignoreDups = true;
                ignoreAllDups = true;
                ignoreSpace = true;
                share = true;
              };

              setOptions = [
                "AUTO_CD"
                "HIST_FCNTL_LOCK"
                "HIST_VERIFY"
                "INTERACTIVE_COMMENTS"
              ];

              initContent = lib.mkMerge [
                # Order 920: Load fzf-tab AFTER compinit (570) and fzf (910),
                # but BEFORE atuin (1000) and fast-syntax-highlighting (1200).
                (lib.mkOrder 920 ''
                  source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

                  # Completion styling for fzf-tab
                  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
                  zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
                  zstyle ':completion:*' menu no
                  zstyle ':completion:*:descriptions' format '[%d]'
                  zstyle ':fzf-tab:*' switch-group '<' '>'
                  zstyle ':fzf-tab:complete:cd:*' fzf-preview '${lib.getExe pkgs.lsd} -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath'
                '')

                # Order 1000: Ergonomic terminal keybindings (replaces OMZ key-bindings.zsh)
                (lib.mkOrder 1000 ''
                  bindkey '^[[1;5C' forward-word   # Ctrl+Right
                  bindkey '^[[1;5D' backward-word  # Ctrl+Left
                  bindkey '^[[3~'   delete-char    # Delete
                  bindkey '^[[H'    beginning-of-line
                  bindkey '^[[F'    end-of-line
                '')

                # Order 2000: Initialize zoxide strictly last so its precmd/chpwd hooks
                # are never displaced by ZLE plugins (prevents _ZO_DOCTOR warning).
                (lib.mkOrder 2000 ''
                  eval "$(${lib.getExe config.programs.zoxide.package} init zsh)"
                '')
              ];
            };

            # ------------------------------------------------------------------
            # 2. FZF (Fuzzy Finder backend for Ctrl-T, Alt-C, and fzf-tab)
            # ------------------------------------------------------------------
            fzf = {
              enable = true;
              enableZshIntegration = true; # Injected at order 910
              defaultOptions = [
                "--height=40%"
                "--layout=reverse"
                "--border=rounded"
                "--info=inline"
              ];
            };

            # ------------------------------------------------------------------
            # 3. Atuin (SQLite-backed Shell History on Ctrl-R)
            # ------------------------------------------------------------------
            atuin = {
              enable = true;
              enableZshIntegration = true; # Injected at order 1000 (overrides fzf Ctrl-R)
              flags = [
                "--disable-up-arrow" # Keep Up-Arrow fast/local; use Ctrl-R for Atuin TUI
              ];
              settings = {
                auto_sync = false;
                update_check = false;
                search_mode = "fuzzy";
                filter_mode = "global";
                filter_mode_shell_up_key_binding = "directory";
                style = "compact";
                inline_height = 20;
                enter_accept = true;
              };
            };

            # ------------------------------------------------------------------
            # 4. Zoxide (Smart Directory Jumper)
            # ------------------------------------------------------------------
            zoxide = {
              enable = true;
              # Disabled here because we initialize zoxide at order 2000 in
              # programs.zsh.initContent to avoid home-manager#9349.
              enableZshIntegration = false;
            };

            # ------------------------------------------------------------------
            # 5. Starship (Cross-Shell Rust Prompt Engine)
            # ------------------------------------------------------------------
            starship = {
              enable = true;
              enableZshIntegration = true;
              settings = {
                add_newline = false;
                command_timeout = 1000;

                character = {
                  success_symbol = "[❯](bold green)";
                  error_symbol = "[❯](bold red)";
                  vicmd_symbol = "[❮](bold yellow)";
                };

                directory = {
                  truncation_length = 3;
                  truncate_to_repo = true;
                  style = "bold cyan";
                };

                git_branch = {
                  symbol = "🌱 ";
                  style = "bold purple";
                };

                git_status = {
                  style = "bold red";
                  ahead = "⇡\${count}";
                  behind = "⇣\${count}";
                  diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
                };

                cmd_duration = {
                  min_time = 500;
                  format = "took [$duration](bold yellow) ";
                };

                nix_shell = {
                  symbol = "❄️ ";
                  format = "via [$symbol$state( \\($name\\))](bold blue) ";
                };
              };
            };
          };
        };
    };
}
