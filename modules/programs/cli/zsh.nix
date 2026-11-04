# modules/programs/cli/zsh.nix
{ ... }:
{
  den.aspects.zsh = {
    nixos =
      { ... }:
      {
        programs.zsh.enable = true;
        environment.pathsToLink = [ "/share/zsh" ];
      };

    # Projected to `users.users.elio.shell` via `den.batteries.host-aspects`
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
        home.packages = [
          pkgs.zsh-completions
        ];

        programs = {
          zsh = {
            enable = true;
            # Match ZDOTDIR="$HOME/.config/zsh" in modules/system/xdg.nix
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
              # Match HISTFILE="$HOME/.local/state/zsh/history" in modules/system/xdg.nix
              path = "${config.xdg.stateHome}/zsh/history";
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
              (lib.mkOrder 920 ''
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

              (lib.mkOrder 2000 ''
                eval "$(${lib.getExe config.programs.zoxide.package} init zsh)"
              '')
            ];
          };

          fzf = {
            enable = true;
            enableZshIntegration = true;
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
            enableZshIntegration = true;
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

          zoxide = {
            enable = true;
            enableZshIntegration = false;
          };

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
