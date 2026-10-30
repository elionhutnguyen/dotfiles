{ ... }:
{
  den.aspects.bootloader.nixos = {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
