{ ... }:
{
  den.aspects.hw-tools.nixos = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.pciutils # lspci
      pkgs.usbutils # lsusb
    ];
  };
}
