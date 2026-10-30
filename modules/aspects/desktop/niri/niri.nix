{ ... }:
{
  den.aspects.niri = {
    nixos = {
      programs.niri = {
        enable = true;
        useNautilus = false;
      };
    };

    homeManager = { config, ... }:
      let
        sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/desktop/niri";
      in
      {
        xdg.configFile."niri".source =
          config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
      };
  };
}
