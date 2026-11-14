# aspects/vcs.nix
# Aspect: Colocated Git + Jujutsu VCS suite with Delta, Difftastic, and GH
_: {
  den.aspects.vcs.homeManager =
    { config, lib, ... }:
    let
      difftExe = lib.getExe config.programs.difftastic.package;
      sshSigningKey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    in
    {
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
          options = {
            color = "always";
            display = "side-by-side-show-both";
          };
        };

        git = {
          enable = true;

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
            url."git@github.com:" = {
              pushInsteadOf = "https://github.com/";
              insteadOf = "ssh://git@github.com/";
            };

            init.defaultBranch = "main";
            core = {
              editor = "nvim";
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
}
