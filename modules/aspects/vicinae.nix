{ ... }:
{
  den.aspects.vicinae = {
    nixos = { };

    homeManager = { config, ... }:
      let
        dotconfigs = "${config.home.homeDirectory}/dotfiles/dotconfigs";
      in
      {
        programs.vicinae = {
          enable = true;
          systemd.enable = true;
        };

        xdg.configFile."vicinae".source =
          config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/vicinae";
      };
  };
}
