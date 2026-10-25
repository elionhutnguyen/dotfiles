{ pkgs, ... }:

{
  # --- Desktop Compositor & Greeter ---
  programs.umbriel.enable = true;
  programs.noctalia.enable = true;
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings.keyboard.layout = "us";
  };
  services.accounts-daemon.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # --- Audio & Bluetooth ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # --- Input Method (Fcitx5) ---
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-bamboo
        qt6Packages.fcitx5-chinese-addons
      ];
    };
  };

  # --- Fonts ---
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK TC" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK TC" ];
        serif = [ "Noto Serif" "Noto Serif CJK TC" ];
      };
    };
  };
}
