{ ... }:
{
  den.aspects.onlyoffice.homeManager = { config, pkgs, ... }: {
    programs.onlyoffice = {
      enable = true;
    };
  };
}
