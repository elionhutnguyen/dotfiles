# modules/nixos/bluetooth.nix
# Vertical Module: System Bluetooth controller stack
{ ... }:
{
  den.default.nixos =
    { config, lib, ... }:
    let
      cfg = config.my.bluetooth;
    in
    {
      options.my.bluetooth = {
        enable = lib.mkEnableOption "system Bluetooth stack";

        powerOnBoot = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Power up the Bluetooth controller automatically on boot.";
        };
      };

      config = lib.mkIf cfg.enable {
        hardware.bluetooth = {
          enable = true;
          powerOnBoot = cfg.powerOnBoot;
        };
      };
    };
}
