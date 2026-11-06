# aspects/theming.nix
# Horizontal Aspect: Cross-cutting typography & TokyoNight palette pushed outward to oblivious modules
_:
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
        my = {
          noctalia = {
            fontFamily = "Noto Sans";
            theme = "Tokyo-Night";
          };

          cli-tools.btopTheme = "tokyo-night";

          niri = {
            activeBorderColor = "#7aa2f7";
            inactiveBorderColor = "#24283b";
          };

          ghostty = {
            fontFamily = monoFont;
            inherit fontSize;
            theme = "TokyoNight Night";
          };

          neovim = {
            fontFamily = monoFont;
            inherit fontSize;
            colorscheme = "tokyonight-night";
          };

          vcs = {
            deltaTheme = "ansi";
          };

          antigravity = {
            colorScheme = "tokyo night";
          };
        };

        dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

        gtk = {
          enable = true;
          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome-themes-extra;
          };
        };

        qt = {
          enable = true;
          platformTheme.name = "gtk3";
          style.name = "adwaita-dark";
        };

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
