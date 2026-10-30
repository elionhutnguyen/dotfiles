{ config, ... }:
let
  sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/desktop/niri";
in
{
  den.aspects.niri = {
    nixos = {
      programs.niri.enable = true;
    };

    homeManager = {
      xdg.configFile."niri".source =
        config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
    };
  };
}
