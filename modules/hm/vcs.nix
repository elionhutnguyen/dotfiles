# modules/hm/vcs.nix
# Vertical Module: Git, Jujutsu, Delta, Difftastic & GH (100% user-oblivious options)
_: {
  den.default.homeManager =
    { config, lib, ... }:
    let
      cfg = config.my.vcs;
      difftExe = lib.getExe config.programs.difftastic.package;
    in
    {
      options.my.vcs = {
        enable = lib.mkEnableOption "colocated Git + Jujutsu VCS suite with Delta, Difftastic, and GH";

        userName = lib.mkOption {
          type = lib.types.str;
          default = config.home.username;
          description = "Author name for Git and Jujutsu commits.";
        };

        userEmail = lib.mkOption {
          type = lib.types.str;
          default = "${config.home.username}@localhost";
          description = "Author email address for Git and Jujutsu commits.";
        };

        sshSigningKey = lib.mkOption {
          type = lib.types.str;
          default = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
          description = "Path to the SSH public key used for commit signing.";
        };

        editor = lib.mkOption {
          type = lib.types.str;
          default = "nvim";
          description = "Interactive editor binary for Git, Jujutsu, and GitHub CLI.";
        };

        deltaTheme = lib.mkOption {
          type = lib.types.str;
          default = "ansi";
          description = "Syntax-highlighting theme for Delta pager.";
        };
      };

      config = lib.mkIf cfg.enable {
        services.ssh-agent.enable = true;

        programs = {
          ssh = {
            enable = true;
            enableDefaultConfig = false;
            settings = {
              "*" = {
                AddKeysToAgent = "yes";
              };
            };
          };

          delta = {
            enable = true;
            enableGitIntegration = true;
            enableJujutsuIntegration = true;
            options = {
              navigate = true;
              side-by-side = true;
              line-numbers = true;
              dark = true;
              syntax-theme = cfg.deltaTheme;
              decorations = {
                commit-decoration-style = "bold yellow box ul";
                file-style = "bold cyan ul";
                file-decoration-style = "none";
                hunk-header-decoration-style = "cyan box ul";
              };
            };
          };

          difftastic = {
            enable = true;
            git.enable = false;
            options = {
              background = "dark";
              color = "always";
              display = "side-by-side-show-both";
            };
          };

          git = {
            enable = true;

            signing = {
              format = "ssh";
              key = cfg.sshSigningKey;
              signByDefault = true;
            };

            ignores = [
              ".direnv/"
              ".envrc.local"
              "result"
              "result-*"
              "*.swp"
              ".DS_Store"
            ];

            settings = {
              user = {
                name = cfg.userName;
                email = cfg.userEmail;
              };

              url."git@github.com:".insteadOf = [
                "https://github.com/"
                "ssh://git@github.com/"
              ];

              init.defaultBranch = "main";
              core = {
                inherit (cfg) editor;
                autocrlf = "input";
                untrackedCache = true;
              };

              diff = {
                algorithm = "histogram";
                colorMoved = "default";
                mnemonicPrefix = true;
                renames = true;
              };

              fetch = {
                prune = true;
                pruneTags = true;
                all = true;
              };

              pull.rebase = true;
              push = {
                default = "simple";
                autoSetupRemote = true;
                followTags = true;
              };

              rebase = {
                autoSquash = true;
                autoStash = true;
                updateRefs = true;
              };

              rerere = {
                enabled = true;
                autoupdate = true;
              };

              merge.conflictstyle = "zdiff3";
              commit.verbose = true;
              help.autocorrect = "prompt";

              alias = {
                dft = "-c diff.external=${difftExe} diff";
                dshow = "-c diff.external=${difftExe} show --ext-diff";
                dlog = "-c diff.external=${difftExe} log -p --ext-diff";

                st = "status -sb";
                lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
                unstage = "restore --staged";
              };
            };
          };

          jujutsu = {
            enable = true;
            settings = {
              user = {
                name = cfg.userName;
                email = cfg.userEmail;
              };

              ui = {
                default-command = "log";
                inherit (cfg) editor;
              };

              git = {
                auto-local-bookmark = false;
                write-change-id-header = true;
              };

              signing = {
                behavior = "own";
                backend = "ssh";
                key = cfg.sshSigningKey;
              };

              merge-tools.difft = {
                program = difftExe;
                diff-args = [
                  "--color=always"
                  "$left"
                  "$right"
                ];
              };

              aliases = {
                dft = [
                  "diff"
                  "--tool"
                  "difft"
                ];
                tug = [
                  "bookmark"
                  "move"
                  "--from"
                  "heads(::@- & bookmarks())"
                  "--to"
                  "@-"
                ];
              };
            };
          };

          gh = {
            enable = true;
            gitCredentialHelper.enable = true;
            settings = {
              git_protocol = "ssh";
              inherit (cfg) editor;
              prompt = "enabled";
            };
          };
        };
      };
    };
}
