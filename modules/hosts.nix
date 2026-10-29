{ den, ... }:
{
  # 1. Entity declaration only:
  den.hosts.x86_64-linux.elio = {
    users.elio = {
      classes = [ "homeManager" "user" ];
    };
  };

  # 2. Host-level NixOS configuration goes into the host's aspect:
  den.aspects.elio.nixos = {
    imports = [ ./_hardware-configuration.nix ];
    services.fstrim.enable = true; # SSD TRIM attached directly to disk hardware
    time.timeZone = "Asia/Taipei";
  };

  den.default = {
    nixos.system.stateVersion = "25.05";
    homeManager.home.stateVersion = "25.05";
    nixos.home-manager.backupFileExtension = "backup";
    includes = [
      den.batteries.define-user
      den.batteries.hostname
      den.batteries.primary-user
    ];
  };

  den.aspects.elio.user.extraGroups = [
    "audio" "video" "input" "dialout" "libvirtd" "docker"
  ];

  den.aspects.elio.includes = with den.aspects; [
    nix
    bootloader
    pipewire
    power
    graphics

    greetd
    wayland-services
    fonts
    fcitx5

    niri
    noctalia
    vicinae

    ghostty
    neovim
    zsh
    git
    mpv
    vscodium
    anki
    brave-origin
    onlyoffice
    comma
    faugus-launcher
    yazi
  ];
}
