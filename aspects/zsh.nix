# aspects/zsh.nix
# Aspect: Multi-class Zsh shell (system registration, login shell & HM fzf-tab/Atuin/Zoxide/Starship)
_: {
  den.aspects.zsh = {
    nixos = {
      programs.zsh.enable = true;
      environment.pathsToLink = [ "/share/zsh" ];
    };

    user =
      { pkgs, ... }:
      {
        shell = pkgs.zsh;
      };

    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        programs = {
          zsh = {
            enable = true;
            dotDir = "${config.xdg.configHome}/zsh";
            defaultKeymap = "emacs";

            shellAliases = {
              hotspot-on = "nmcli device wifi hotspot";
              hotspot-off = "nmcli connection down Hotspot";
              hotspot-qr = "nmcli device wifi show-password";
            };

            autosuggestion = {
              enable = true;
              strategy = [
                "history"
                "completion"
              ];
            };

            fastSyntaxHighlighting.enable = true;

            history = {
              path = "${config.xdg.stateHome}/zsh/history";
              size = 100000;
              save = 100000;
              extended = true;
              expireDuplicatesFirst = true;
              ignoreAllDups = true;
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
                zstyle ':fzf-tab:complete:cd:*' fzf-preview '${lib.getExe' pkgs.coreutils "ls"} -1 --color=always $realpath'
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
