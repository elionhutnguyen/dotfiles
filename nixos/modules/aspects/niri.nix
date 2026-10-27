{ ... }:
let
  dotconfigs = "/home/elio/dotfiles/dotconfigs";
in
{
  den.aspects.niri = {
    nixos = { pkgs, ... }: {
      programs.niri.enable = true;
    };

    homeManager = { config, ... }: {
      xdg.configFile."niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/niri/config.kdl";
    };
  };
}
