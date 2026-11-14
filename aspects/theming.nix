# aspects/theming.nix
# Aspect: Cross-cutting typography & Catppuccin palette across system and user applications
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

    homeManager =
      { pkgs, ... }:
      {
        programs = {
          noctalia.settings = {
            shell.font_family = "Noto Sans";
            theme = {
              mode = "auto";
              source = "builtin";
              builtin = "Catppuccin";
              sync_color_scheme = true;
            };
          };

          btop.settings.color_theme = "TTY";

          ghostty.settings = {
            font-family = monoFont;
            font-size = fontSize;
            theme = "light:Catppuccin Latte,dark:Catppuccin Mocha";
            minimum-contrast = 3.5;
          };

          delta.options.syntax-theme = "ansi";

          antigravity-cli.settings.colorScheme = "terminal";
        };

        gtk = {
          enable = true;
          theme = {
            name = "Adwaita";
            package = pkgs.gnome-themes-extra;
          };
        };

        qt = {
          enable = true;
          platformTheme.name = "gtk3";
          style.name = "adwaita";
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
