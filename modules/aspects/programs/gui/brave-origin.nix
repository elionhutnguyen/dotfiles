{ ... }:
{
  den.aspects.brave-origin.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.brave-origin ];
  };
}
