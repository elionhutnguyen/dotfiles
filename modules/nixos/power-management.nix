# modules/nixos/power-management.nix
# Vertical Module: Power profiles daemon & laptop battery charge threshold udev control
{ ... }:
{
  den.default.nixos =
    { config, lib, ... }:
    let
      cfg = config.my.power-management;
    in
    {
      options.my.power-management = {
        enable = lib.mkEnableOption "power-profiles-daemon and battery charge threshold enforcement";

        maxChargePercent = lib.mkOption {
          type = lib.types.ints.between 50 100;
          default = 80;
          description = "Maximum battery charge percentage limit.";
        };

        extraKernelModules = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Vendor WMI kernel modules (e.g. asus_nb_wmi) exposing charge_control_end_threshold.";
        };
      };

      config = lib.mkIf cfg.enable {
        services.power-profiles-daemon.enable = true;
        services.upower.enable = true;

        boot.kernelModules = cfg.extraKernelModules;

        services.udev.extraRules = ''
          ACTION=="add|change", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}!="", ATTR{charge_control_end_threshold}="${toString cfg.maxChargePercent}"
        '';
      };
    };
}
