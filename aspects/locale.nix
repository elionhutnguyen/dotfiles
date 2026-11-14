# aspects/locale.nix
# Aspect: Cross-class localization, CJK/Vietnamese input method & Taipei solar coordinates
_:
let
  defaultLocale = "en_GB.UTF-8";
in
{
  den.aspects.locale = {
    nixos =
      { pkgs, ... }:
      {
        time.timeZone = "Asia/Taipei";

        i18n = {
          inherit defaultLocale;
          extraLocales = [
            "ja_JP.UTF-8/UTF-8"
            "zh_TW.UTF-8/UTF-8"
          ];
          extraLocaleSettings = {
            LC_ADDRESS = defaultLocale;
            LC_IDENTIFICATION = defaultLocale;
            LC_MEASUREMENT = defaultLocale;
            LC_MONETARY = defaultLocale;
            LC_NAME = defaultLocale;
            LC_NUMERIC = defaultLocale;
            LC_PAPER = defaultLocale;
            LC_TELEPHONE = defaultLocale;
            LC_TIME = defaultLocale;
          };

          inputMethod = {
            enable = true;
            type = "fcitx5";
            fcitx5 = {
              waylandFrontend = true;
              addons = with pkgs; [
                fcitx5-bamboo
                qt6Packages.fcitx5-chinese-addons
                qt6Packages.fcitx5-configtool
                fcitx5-gtk
              ];
            };
          };
        };
      };

    homeManager = {
      programs.noctalia.settings = {
        location = {
          auto_locate = false;
          latitude = 25.03;
          longitude = 121.56;
        };
        nightlight.enabled = true;
      };
    };
  };
}
