{ ... }:
{
  den.aspects.boot.nixos = { pkgs, ... }: {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.tmp.cleanOnBoot = true;
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
