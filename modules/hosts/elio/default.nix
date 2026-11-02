{ den, ... }:
{
  # 1. Host Entity Declaration
  den.hosts.x86_64-linux.elio-laptop = {
    users.elio = {
      classes = [ "homeManager" "user" ];
    };
  };

  # 2. Hardware Specification
  den.aspects.elio-laptop.nixos = {
    imports = [ ./_hardware-configuration.nix ];
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
    greetd
    desktop-env
    niri
    noctalia
    vicinae

    # CLI & Terminal Tools
    zsh
    cli-tools
    ghostty
    neovim
    yazi
    vscode
    ai

    # GUI Applications
    gui-apps
    firefox
    mpv
    gaming
  ];
}
