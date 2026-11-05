# aspects/theming.nix
# Horizontal Aspect: Cross-cutting typography & TokyoNight palette pushed outward to oblivious modules
{ ... }:
let
  monoFont = "JetBrainsMono Nerd Font";
  fontSize = 12;
in
{
  den.aspects.theming = {
    nixos =
      { pkgs, ... }:
      {
        fonts = {
          enableDefaultPackages = true;
          packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-color-emoji
            nerd-fonts.jetbrains-mono
          ];
          fontconfig.defaultFonts = {
            serif = [
              "Noto Serif"
              "Noto Serif CJK TC"
              "Noto Serif CJK SC"
            ];
            sansSerif = [
              "Noto Sans"
              "Noto Sans CJK TC"
              "Noto Sans CJK SC"
            ];
            monospace = [ monoFont ];
            emoji = [ "Noto Color Emoji" ];
          };
        };
      };

    # Outward Push: Configure local options of oblivious vertical HM modules
    homeManager =
      { pkgs, ... }:
      {
        my.noctalia = {
          fontFamily = "Noto Sans";
          theme = "Tokyo-Night";
        };

        my.cli-tools.btopTheme = "tokyo-night";

        my.niri = {
          activeBorderColor = "#7aa2f7";
          inactiveBorderColor = "#24283b";
        };

        my.ghostty = {
          fontFamily = monoFont;
          fontSize = fontSize;
          theme = "TokyoNight Night";
        };

        my.neovim = {
          fontFamily = monoFont;
          fontSize = fontSize;
          colorscheme = "tokyonight-night";
        };

        my.vcs = {
          deltaTheme = "ansi";
        };

        my.antigravity = {
          colorScheme = "tokyo night";
        };

        dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

        home.pointerCursor = {
          enable = true;
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
          size = 24;
          gtk.enable = true;
          x11.enable = true;
        };
      };
  };
}
