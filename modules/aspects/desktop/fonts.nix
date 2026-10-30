{ ... }:
{
  den.aspects.fonts.nixos = { pkgs, ... }: {
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
        serif = [ "Noto Serif" "Noto Serif CJK TC" "Noto Serif CJK SC" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK TC" "Noto Sans CJK SC" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
