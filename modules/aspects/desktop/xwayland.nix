{ ... }:
{
  den.aspects.xwayland.nixos = { pkgs, ... }: {
    programs.xwayland.enable = true;
    environment.systemPackages = [ pkgs.xwayland-satellite ];
  };
}
