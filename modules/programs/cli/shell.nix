{ ... }:
{
  den.aspects.shell = {
    nixos = { pkgs, ... }: {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
      };
      users.defaultUserShell = pkgs.zsh;
      programs.git.enable = true;
    };

    homeManager = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
      };

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
