{ ... }:
let
  dotconfigs = "/home/elio/dotfiles/dotconfigs";
in
{
  den.aspects.i18n.nixos = { pkgs, ... }: {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-bamboo
          qt6Packages.fcitx5-chinese-addons
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
    xdg.configFile."fcitx5/config".source =
      config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/fcitx5/config";
    xdg.configFile."fcitx5/profile".source =
      config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/fcitx5/profile";
  };
}
