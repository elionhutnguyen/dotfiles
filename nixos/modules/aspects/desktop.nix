{ pkgs, config, ... }:
let
  dotfilesRoot = "/home/elio/.dotfiles/dotfiles-src";
in
{
  den.aspects.desktop.nixos = {
    environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  };

  den.aspects.desktop.homeManager = { config, ... }: {
    # Rule 1 & 2
    programs.ghostty = {
      enable = true;
      settings = { config-file = "${dotfilesRoot}/ghostty/config"; };
    };

    programs.mpv = {
      enable = true;
      extraConfig = "include=${dotfilesRoot}/mpv/mpv.conf";
    };

    programs.firefox = {
      enable = true;
      profiles.default = { id = 0; name = "default"; isDefault = true; };
    };

    programs.brave = {
      enable = true;
      extensions = [ { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } ];
    };

    # Rule 1 & 3
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
    
    xdg.configFile."VSCodium/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/vscodium/settings.json";

    home.packages = with pkgs; [ anki onlyoffice-bin ];
  };
}
