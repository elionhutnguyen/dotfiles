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
        dotconfigs = "${config.home.homeDirectory}/dotfiles/dotconfigs";
      in
      {
        xdg.configFile."noctalia".source =
          config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/noctalia";
      };
  };
}
