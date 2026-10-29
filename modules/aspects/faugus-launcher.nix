{ ... }:
{
  den.aspects.faugus-launcher.homeManager = { config, pkgs, ... }: {
    home.packages = [
      pkgs.faugus-launcher
    ];
  };
}
