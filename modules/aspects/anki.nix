{ ... }:
{
  den.aspects.anki.homeManager = { config, pkgs, ... }: {
    programs.anki = {
      enable = true;
      addons = with pkgs.ankiAddons; [
	passfail2
	review-heatmap
      ];
    };
  };
}
