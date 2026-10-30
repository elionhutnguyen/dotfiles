{ ... }:
{
  den.aspects.brave.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.brave-origin ];
  };
}
