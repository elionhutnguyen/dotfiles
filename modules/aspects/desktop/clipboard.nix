{ ... }:
{
  den.aspects.clipboard.nixos = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.wl-clipboard ];
  };
}
