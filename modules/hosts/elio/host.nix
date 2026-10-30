{ den, ... }:
{
  # 1. Host Entity Declaration
  den.hosts.x86_64-linux.elio = {
    users.elio = {
      classes = [ "homeManager" "user" ];
    };
  };

  # 2. Host-Level Hardware Import
  den.aspects.elio.nixos = {
    imports = [ ./_hardware-configuration.nix ];
  };

  # 3. Global Baseline Settings
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

  # 4. User Group Assignments
  den.aspects.elio.user.extraGroups = [
    "wheel"
    "audio"
    "video"
    "input"
    "dialout"
    "networkmanager"
    "libvirtd"
    "docker"
  ];

  # 5. Master Aspect Inclusions
  den.aspects.elio.includes = with den.aspects; [
    # Core System
    nix-daemon
    locale
    zram
    oomd
    journald

    # Hardware & Power
    bootloader
    graphics-nvidia
    cardwire
    power-profiles
    battery-charge-limit
    fstrim

    # System Daemons & Services
    networkmanager
    bluetooth
    pipewire
    wiremix
    playerctl
    ananicy
    greetd
    udisks
    gvfs
    udiskie

    # Desktop Environment & Wayland Session
    niri
    ghostty
    noctalia
    vicinae
    xwayland
    swaylock
    swayidle
    wlsunset
    portals
    polkit
    fonts
    fcitx5
    brightnessctl
    clipboard
    xdg-user-dirs

    # Programs: Terminal (CLI & TUI)
    git
    neovim
    yazi
    zsh
    fzf
    zoxide
    ripgrep
    fd
    trash-cli
    _7zz-rar
    unrar
    btop
    nvtop
    pciutils
    usbutils
    comma

    # Programs: Graphical Applications
    mpv
    vscodium
    brave-origin
    anki
    onlyoffice
    faugus-launcher
  ];
}
