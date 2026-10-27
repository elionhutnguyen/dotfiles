{ pkgs, config, ... }:
let
  dotfilesRoot = "/home/elio/.dotfiles/dotfiles-src";
in
{
  den.aspects.i18n.nixos = {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-bamboo
          fcitx5-chinese-addons
          fcitx5-gtk
        ];
      };
    };

    environment.sessionVariables = {
      XMODIFIERS = "@im=fcitx";
      QT_IM_MODULE = "fcitx";
      GTK_IM_MODULE = "fcitx";
    };
  };

  den.aspects.i18n.homeManager = { config, ... }: {
    # Rule 3
    xdg.configFile."fcitx5/config".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/fcitx5/config";
    xdg.configFile."fcitx5/profile".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/fcitx5/profile";
  };
}
