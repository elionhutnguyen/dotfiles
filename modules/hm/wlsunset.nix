# modules/hm/wlsunset.nix
# Vertical Module: Wayland night-light gamma adjuster
{ ... }:
{
  den.default.homeManager =
    { config, lib, ... }:
    let
      cfg = config.my.wlsunset;
    in
    {
      options.my.wlsunset = {
        enable = lib.mkEnableOption "wlsunset Wayland night-light service";

        latitude = lib.mkOption {
          type = lib.types.str;
          default = "25.03";
          description = "Geographic latitude for solar elevation calculation.";
        };

        longitude = lib.mkOption {
          type = lib.types.str;
          default = "121.56";
          description = "Geographic longitude for solar elevation calculation.";
        };
      };

      config = lib.mkIf cfg.enable {
        services.wlsunset = {
          enable = true;
          latitude = cfg.latitude;
          longitude = cfg.longitude;
        };
      };
    };
}
