{ ... }:
{
  den.aspects.brave-origin.homeManager = { config, pkgs, ... }: {
    home.packages = [
	pkgs.brave-origin
    ];
  };
}
