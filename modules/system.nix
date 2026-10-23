{ pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Localization & Timezone
  time.timeZone = "Asia/Taipei";
  i18n.defaultLocale = "en_GB.UTF-8";
  services.xserver.xkb.layout = "us";
  console.keyMap = "us";
  
  # Ensure persistent data folder exists and has user permissions
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

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  # System Applications
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    git
    alacritty
    pciutils
    noctalia
  ];
}
