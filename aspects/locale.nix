# aspects/locale.nix
# Horizontal Aspect: Cross-class localization & Taipei solar coordinates
{ ... }:
let
  defaultLocale = "en_GB.UTF-8";
in
{
  den.aspects.locale = {
    nixos = {
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
      };
    };

    # Outward Push: Configure local options of the vertical `wlsunset` module
    homeManager = {
      my.wlsunset = {
        enable = true;
        latitude = "25.03";
        longitude = "121.56";
      };
    };
  };
}
