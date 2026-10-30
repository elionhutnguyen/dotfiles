{ ... }:
{
  den.aspects.playerctl.homeManager = { pkgs, ... }: {
    services.playerctld.enable = true;
    home.packages = [ pkgs.playerctl ];
  };
}
