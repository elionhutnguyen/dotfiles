# aspects/cli-workspace.nix
# Horizontal Aspect: Cross-class CLI environment weaving (nixos, user, homeManager)
{ ... }:
{
  den.aspects.cli-workspace = {
    nixos = {
      programs.zsh.enable = true;
      environment.pathsToLink = [ "/share/zsh" ];
      programs.git.enable = true;
      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };

    user =
      { pkgs, ... }:
      {
        shell = pkgs.zsh;
      };

    homeManager = {
      my.zsh.enable = true;
      my.neovim.enable = true;
      my.vcs = {
        enable = true;
        editor = "nvim";
      };
      my.yazi.enable = true;
      my.cli-tools.enable = true;
    };
  };
}
