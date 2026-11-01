{ ... }:
{
  den.aspects.gaming.homeManager = { pkgs, ... }: {
    home.packages = with pkgs; [
      faugus-launcher
      steam-run
      nwjs
    ];
  };
}
