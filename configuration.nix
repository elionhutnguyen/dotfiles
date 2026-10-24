{ config, pkgs, ... }:

let
  # Battery charge limit (80%)
  setBatteryLimit = pkgs.writeShellScript "set-battery-limit" ''
    for f in /sys/class/power_supply/BAT*/charge_control_end_threshold; do
      [ -f "$f" ] && echo 80 > "$f"
    done
  '';

  # Dynamic GPU runner: NVIDIA on AC, AMD iGPU on battery
  autoGpu = pkgs.writeShellScriptBin "auto-gpu" ''
    [ $# -eq 0 ] && { echo "Usage: auto-gpu <command> [args...]" >&2; exit 1; }
    for ps in /sys/class/power_supply/*/online; do
      [ -f "$ps" ] && [ "$(cat "$ps")" -eq 1 ] && exec nvidia-offload "$@"
    done
    exec env DRI_PRIME=0 "$@"
  '';
in
{
  imports = [ ./hardware-configuration.nix ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "asus-nb-wmi" ];

  # Power & Battery
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="power_supply", KERNEL=="BAT?", ATTR{charge_control_end_threshold}="80"
    ACTION=="add", KERNEL=="asus-nb-wmi", RUN+="${setBatteryLimit}"
  '';
  powerManagement.resumeCommands = "${setBatteryLimit}";
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Graphics & Hybrid GPU
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.switcherooControl.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # GTX 1650 (TU117) requires proprietary module
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:5:0:0"; # Verify with: lspci | grep -E "VGA|3D"
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Desktop & Display
  programs.umbriel = {
    enable = true;
    settings.general.autostart = [ "noctalia" ];
  };
  programs.noctalia.enable = true;
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings.keyboard.layout = "us";
  };
  services.accounts-daemon.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Audio & Bluetooth
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

  # Locale, Fonts & Input
  time.timeZone = "Asia/Taipei";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.supportedLocales = [
    "en_GB.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "zh_TW.UTF-8/UTF-8"
  ];
  services.xserver.xkb.layout = "us";
  console.keyMap = "us";

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

  # Networking & User
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  users.users.elio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };
  systemd.tmpfiles.rules = [ "d /home/elio/data 0755 elio users -" ];

  # Programs & Packages
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.firefox.enable = true;
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    autoGpu
    ghostty
    pciutils
  ];

  # Nix Settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ "https://umbriel.cachix.org" ];
    extra-trusted-public-keys = [
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
    ];
  };

  system.stateVersion = "26.05";
}
