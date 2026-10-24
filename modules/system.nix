{ pkgs, ... }:

{
  # Bootloader (UEFI)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Localization & Timezone
  time.timeZone = "Asia/Taipei";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.supportedLocales = [
    "en_GB.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "zh_TW.UTF-8/UTF-8"
  ];
  services.xserver.xkb.layout = "us";
  console.keyMap = "us";

  # Ensure persistent data folder exists and has user permissions on boot
  systemd.tmpfiles.rules = [
    "d /home/elio/data 0755 elio users -"
  ];

  # Fcitx5 IME (Bamboo + Traditional Chinese Pinyin)
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

  # Fonts & Traditional Chinese Glyph Prioritization
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

  # Wayland text-input / Ozone flag for Electron & Chromium apps
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # --- System Applications (via programs.* modules) ---
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.firefox.enable = true;
  programs.git.enable = true;

  # Enabled at system level
  programs.noctalia.enable = true;

  # Stateless CLI utilities
  environment.systemPackages = with pkgs; [
    pciutils
    ghostty-bin
  ];
}
