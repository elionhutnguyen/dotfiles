{ ... }:
{
  den.aspects.pciutils.nixos = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.pciutils ];
  };
}
