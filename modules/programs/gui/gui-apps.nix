{ ... }:
{
  den.aspects.gui-apps.homeManager = { pkgs, ... }: {
    # Standalone Packages
    home.packages = with pkgs; [
      anki-bin
      brave-origin
      materialgram
    ];

    # Managed GUI Productivity Programs
    programs.vscodium.enable = true;
    programs.onlyoffice.enable = true;
  };
}
