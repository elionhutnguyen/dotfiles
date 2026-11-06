# modules/hm/zsh.nix
# Vertical Module: User-level Zsh shell with fzf-tab, Atuin, Zoxide, and Starship
_: {
  den.default.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.zsh;
    in
    {
      options.my.zsh = {
        enable = lib.mkEnableOption "declarative Zsh shell with fzf-tab, Atuin, Zoxide, and Starship";

        historySize = lib.mkOption {
          type = lib.types.int;
          default = 100000;
          description = "Maximum number of history entries retained by Zsh.";
        };
      };

      config = lib.mkIf cfg.enable {
        programs = {
          zsh = {
            enable = true;
            dotDir = "${config.xdg.configHome}/zsh";
            enableCompletion = true;
            defaultKeymap = "emacs";

            autosuggestion = {
              enable = true;
              strategy = [
                "history"
                "completion"
              ];
            };

            fastSyntaxHighlighting.enable = true;
            syntaxHighlighting.enable = false;

            history = {
              path = "${config.xdg.stateHome}/zsh/history";
              size = cfg.historySize;
              save = cfg.historySize;
              extended = true;
              expireDuplicatesFirst = true;
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
              (lib.mkOrder 850 ''
                source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

                zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
                zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
                zstyle ':completion:*' menu no
                zstyle ':completion:*:descriptions' format '[%d]'
                zstyle ':fzf-tab:*' switch-group '<' '>'
                zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.coreutils}/bin/ls -1 --color=always $realpath'
              '')

              (lib.mkOrder 1000 ''
                bindkey '^[[1;5C' forward-word
                bindkey '^[[1;5D' backward-word
                bindkey '^[[3~'   delete-char
                bindkey '^[[H'    beginning-of-line
                bindkey '^[[F'    end-of-line
              '')
            ];
          };

          fzf = {
            enable = true;
            historyWidget.command = "";
            defaultOptions = [
              "--height=40%"
              "--layout=reverse"
              "--border=rounded"
              "--info=inline"
            ];
          };

          atuin = {
            enable = true;
            flags = [ "--disable-up-arrow" ];
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

          zoxide.enable = true;

          starship = {
            enable = true;
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
