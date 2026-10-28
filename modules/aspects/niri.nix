{ ... }:
{
  den.aspects.niri = {
    nixos = {
      programs.niri.enable = true;
    };

    homeManager = { config, ... }:
      let
        dotconfigs = "${config.home.homeDirectory}/dotfiles/dotconfigs";
      in
      {
        xdg.configFile."niri".source =
          config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/niri";
      };
  };
}
