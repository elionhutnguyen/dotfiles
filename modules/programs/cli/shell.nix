{ ... }:
{
  den.aspects.shell = {
    nixos = { pkgs, ... }: {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      };
      users.defaultUserShell = pkgs.zsh;
      programs.git.enable = true;
    };

    homeManager = {
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
