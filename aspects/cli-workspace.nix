# aspects/cli-workspace.nix
# Horizontal Aspect: Cross-class CLI environment weaving (nixos, user, homeManager)
_: {
  den.aspects.cli-workspace = {
    nixos = {
      programs.zsh.enable = true;
      environment.pathsToLink = [ "/share/zsh" ];
    };

    user =
      { pkgs, ... }:
      {
        shell = pkgs.zsh;
      };

    homeManager.my = {
      zsh.enable = true;
      neovim.enable = true;
      vcs = {
        enable = true;
        editor = "nvim";
      };
      yazi.enable = true;
      cli-tools = {
        enable = true;
        enableHwDiag = true;
      };
      python.enable = true;
    };
  };
}
