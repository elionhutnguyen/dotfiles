{ ... }:
{
  den.aspects.nvtop.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.nvtopPackages.full ];
  };
}
