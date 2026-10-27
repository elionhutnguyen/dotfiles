{ ... }:
let
  dotconfigs = "/home/elio/dotfiles/dotconfigs";
in
{
  den.aspects.desktop.nixos = {
    environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  };

  den.aspects.desktop.homeManager = { config, pkgs, ... }: {
    programs.ghostty = {
      enable = true;
      settings = { config-file = "${dotconfigs}/ghostty/config"; };
    };

    programs.mpv = {
      enable = true;
      extraInput = "include=${dotconfigs}/mpv/mpv.conf";
    };

    programs.firefox = {
      enable = true;
      profiles.default = { id = 0; name = "default"; isDefault = true; };
    };

    programs.vscodium = {
      enable = true;
    };
    
    xdg.configFile."VSCodium/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/vscodium/settings.json";

    home.packages = with pkgs; [ 
      anki 
      onlyoffice-desktopeditors
      brave-origin
    ];
  };
}
