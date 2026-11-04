# modules/programs/cli/vcs.nix
{ ... }:
{
  den.aspects.vcs = {
    nixos =
      { ... }:
      {
        programs.git.enable = true;
      };

    homeManager =
      {
        config,
        osConfig,
        lib,
        pkgs,
        ...
      }:
      let
        gitUserName = config.home.username;
        gitUserEmail = "${config.home.username}@${osConfig.networking.hostName}";
        sshSigningKey = "~/.ssh/id_ed25519.pub";
        deltaExe = lib.getExe config.programs.delta.package;
        difftExe = lib.getExe config.programs.difftastic.package;
      in
      {
        programs = {
          # ------------------------------------------------------------------
          # 1. Delta (Default Line-Oriented Syntax-Highlighting Pager)
          # ------------------------------------------------------------------
          delta = {
            enable = true;
            enableGitIntegration = true;
            enableJujutsuIntegration = true;
            options = {
              navigate = true;
              side-by-side = true;
              line-numbers = true;
              dark = true;
              syntax-theme = "tokyonight_night";
              decorations = {
                commit-decoration-style = "bold yellow box ul";
                file-style = "bold cyan ul";
                file-decoration-style = "none";
                hunk-header-decoration-style = "cyan box ul";
              };
            };
          };

          # ------------------------------------------------------------------
          # 2. Difftastic (Tree-Sitter AST Structural Diff Engine)
          # ------------------------------------------------------------------
          difftastic = {
            enable = true;
            git.enable = false;
            options = {
              background = "dark";
              color = "always";
              display = "side-by-side-show-both";
            };
          };

          # ------------------------------------------------------------------
          # 3. Git (Foundational Storage & Porcelain)
          # ------------------------------------------------------------------
          git = {
            enable = true;

            # SSH Commit Signing
            signing = {
              format = "ssh";
              key = sshSigningKey;
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
                name = gitUserName;
                email = gitUserEmail;
              };

              init.defaultBranch = "main";
              core = {
                editor = "nvim";
                autocrlf = "input";
                fsmonitor = true;
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
                # On-demand AST structural diffs via Difftastic
                dft = "-c diff.external=${difftExe} diff";
                dshow = "-c diff.external=${difftExe} show --ext-diff";
                dlog = "-c diff.external=${difftExe} log -p --ext-diff";

                # Ergonomic inspection aliases
                st = "status -sb";
                lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
                unstage = "restore --staged";
              };
            };
          };

          # ------------------------------------------------------------------
          # 4. Jujutsu (`jj` - Colocated Next-Gen VCS)
          # ------------------------------------------------------------------
          jujutsu = {
            enable = true;
            settings = {
              user = {
                name = gitUserName;
                email = gitUserEmail;
              };

              ui = {
                default-command = "log";
                editor = "nvim";
              };

              git = {
                auto-local-bookmark = false;
                write-change-id-header = true;
              };

              signing = {
                behavior = "own";
                backend = "ssh";
                key = sshSigningKey;
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

          # ------------------------------------------------------------------
          # 5. Lazygit (Terminal UI with Delta <-> Difftastic Pager Cycling)
          # ------------------------------------------------------------------
          lazygit = {
            enable = true;
            settings = {
              gui = {
                nerdFontsVersion = "3";
                showFileTree = true;
                border = "rounded";
              };
              git = {
                overrideGpg = true;
                pagers = [
                  {
                    colorArg = "always";
                    pager = "${deltaExe} --dark --paging=never";
                  }
                  {
                    externalDiffCommand = "${difftExe} --color=always";
                  }
                ];
              };
            };
          };

          # ------------------------------------------------------------------
          # 6. GitHub CLI (`gh`)
          # ------------------------------------------------------------------
          gh = {
            enable = true;
            gitCredentialHelper.enable = true;
            settings = {
              git_protocol = "ssh";
              editor = "nvim";
              prompt = "enabled";
            };
          };
        };
      };
  };
}
