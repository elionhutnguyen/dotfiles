{ den, ... }:
{
  # 1. Host Entity Declaration
  den.hosts.x86_64-linux.elio-laptop = {
    users.elio = {
      classes = [ "homeManager" "user" ];
    };
  };

  # 2. Hardware Specification & Host-Specific Storage
  den.aspects.elio-laptop.nixos = {
    imports = [ ./_hardware-configuration.nix ];

    # Host-specific data partition permissions
    systemd.tmpfiles.rules = [
      "d /home/data 0775 elio users -"
      "z /home/data 0775 elio users -"
    ];
  };

  # 3. User Group Assignments
  den.aspects.elio.user.extraGroups = [
    "wheel"
    "audio"
    "video"
    "input"
    "dialout"
    "networkmanager"
  ];

  # 4. Master Aspect Inclusions
  den.aspects.elio-laptop.includes = with den.aspects; [
    # Core & System
    nix
    base
    locale
    networking
    storage
    media
    tuning
    xdg

    # Hardware Drivers & Power
    nvidia
    power
    bluetooth

    # Desktop & Wayland Session
    desktop-env
    niri

    # CLI & Terminal Tools
    vcs
    zsh
    cli-tools
    ghostty
    neovim
    yazi
    vscode
    goose

    # GUI Applications
    gui-apps
    firefox
    mpv
    gaming
  ];
}
