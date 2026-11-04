# modules/hardware/bluetooth.nix
{ ... }:
{
  den.aspects.bluetooth.nixos = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
