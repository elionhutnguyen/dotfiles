{ ... }:
{
  den.aspects.unrar.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.unrar ];
  };
}
