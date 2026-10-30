{ ... }:
{
  den.aspects.faugus.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.faugus-launcher ];
  };
}
