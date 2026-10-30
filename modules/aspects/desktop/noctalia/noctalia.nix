{ config, ... }:
let
  sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/desktop/noctalia";
in
{
  den.aspects.noctalia = {
    nixos = {
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        recommendedServices.enable = true;
      };
    };

    homeManager = {
      xdg.configFile."noctalia".source =
        config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
    };
  };
}
