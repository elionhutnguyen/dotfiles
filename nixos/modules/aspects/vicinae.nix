{ ... }:
let
  dotconfigs = "/home/elio/dotfiles/dotconfigs/";
in
{
  den.aspects.vicinae = {
    
    nixos = { pkgs, ... }: {
    };

    homeManager = { pkgs, config, ... }: {
      programs.vicinae = {
        enable = true;
        systemd.enable = true;
      };
      xdg.configFile."vicinae/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/vicinae/settings.json";
    };
  
  };
}
