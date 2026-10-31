{ den, ... }:
{
  # 1. Host Entity Declaration
  den.hosts.x86_64-linux.elio-laptop = {
    users.elio = {
      classes = [ "homeManager" "user" ];
    };
  };

  # 2. Hardware Specification
  den.aspects.elio.nixos = {
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
  den.aspects.elio.includes = with den.aspects; [
    # Core & System
    nix
    base
    locale
    networking
    storage
    media
    tuning

    # Hardware Drivers & Power (Clean 1-to-1 matching)
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
    shell
    cli-tools
    ghostty
    neovim
    yazi

    # GUI Applications
    gui-apps
  ];
}
