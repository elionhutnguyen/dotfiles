{ ... }:
{
  den.aspects.faugus-launcher.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.faugus-launcher ];
  };
}
