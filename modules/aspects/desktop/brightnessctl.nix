{ ... }:
{
  den.aspects.brightnessctl.nixos = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.brightnessctl ];
  };
}
