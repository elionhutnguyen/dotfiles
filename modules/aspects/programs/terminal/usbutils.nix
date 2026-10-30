{ ... }:
{
  den.aspects.usbutils.nixos = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.usbutils ];
  };
}
