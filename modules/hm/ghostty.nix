# modules/hm/ghostty.nix
# Vertical Module: Ghostty GPU-accelerated terminal emulator
{ ... }:
{
  den.default.homeManager =
    { config, lib, ... }:
    let
      cfg = config.my.ghostty;
    in
    {
      options.my.ghostty = {
        enable = lib.mkEnableOption "Ghostty terminal emulator";

        fontFamily = lib.mkOption {
          type = lib.types.str;
          default = "JetBrainsMono Nerd Font";
          description = "Primary monospace font family for Ghostty.";
        };

        fontSize = lib.mkOption {
          type = lib.types.int;
          default = 12;
          description = "Font size in points for Ghostty.";
        };

        theme = lib.mkOption {
          type = lib.types.str;
          default = "TokyoNight Night";
          description = "Color theme name for Ghostty.";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.ghostty = {
          enable = true;
          enableZshIntegration = true;
          installVimSyntax = true;
          settings = {
            font-family = cfg.fontFamily;
            font-size = cfg.fontSize;
            theme = cfg.theme;
            window-decoration = false;
            confirm-close-surface = false;
          };
        };
      };
    };
}
