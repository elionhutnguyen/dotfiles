{ ... }:
{
  den.aspects.noctalia = {
    nixos = {
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        recommendedServices.enable = true;
      };
    };

    homeManager = { config, ... }:
      let
        sliceDir = "${config.home.homeDirectory}/dotfiles/modules/desktop/noctalia";
      in
      {
        xdg.configFile."noctalia".source =
          config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
      };
  };
}
