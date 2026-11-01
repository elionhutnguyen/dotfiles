{ ... }:
{
  den.aspects.gui-apps.homeManager = { pkgs, ... }: {
    # Standalone Packages
    home.packages = with pkgs; [
      brave-origin
      materialgram
    ];

    # Managed GUI Productivity Programs
    programs.vscodium.enable = true;
    programs.onlyoffice.enable = true;

    programs.anki = {
      enable = true;
      addons = with pkgs.ankiAddons; [
        passfail2
        review-heatmap
      ];
    };
  };
}
