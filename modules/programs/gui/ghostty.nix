# modules/programs/gui/ghostty.nix
{ ... }:
{
  den.aspects.ghostty.homeManager = {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      installVimSyntax = true;
      settings = {
        font-family = "JetBrainsMono Nerd Font";
        font-size = 12;
        theme = "TokyoNight Night";
        window-decoration = false;
        confirm-close-surface = false;
      };
    };
  };
}
