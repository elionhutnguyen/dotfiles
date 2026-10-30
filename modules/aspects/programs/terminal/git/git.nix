{ config, ... }:
let
  sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/programs/terminal/git";
in
{
  den.aspects.git = {
    nixos = {
      programs.git.enable = true;
    };

    homeManager = {
      xdg.configFile."git".source =
        config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
    };
  };
}
