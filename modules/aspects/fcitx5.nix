{ ... }:
{
  den.aspects.fcitx5 = {
    nixos = { pkgs, ... }: {
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
    };
  };
}
