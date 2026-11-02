{ ... }:
{
  den.aspects.gui-apps.homeManager = { config, pkgs, ... }: 
    {
      # Standalone Packages
      home.packages = with pkgs; [
        anki-bin
        brave-origin
        materialgram
      ];

      # Managed Office Suite
      programs.onlyoffice.enable = true;

    };
}
