{ ... }:
{
  den.aspects.anki.homeManager = { pkgs, ... }: {
    programs.anki = {
      enable = true;
      addons = with pkgs.ankiAddons; [
        passfail2
        review-heatmap
      ];
    };
  };
}
