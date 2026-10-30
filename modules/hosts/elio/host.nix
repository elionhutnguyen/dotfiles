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
    nixos.system.stateVersion = "26.05";
    homeManager.home.stateVersion = "26.05";
    nixos.home-manager.backupFileExtension = "backup";
    nixos.home-manager.useGlobalPkgs = true;
    nixos.home-manager.useUserPackages = true;
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
    # System Foundation & Daemons
    boot
    nix
    locale
    memory
    journald
    fstrim
    ananicy
    networking
    bluetooth
    audio
    udisks
    gvfs

    # Hardware & Power Management
    nvidia
    cardwire
    power

    # Desktop Environment & Wayland Session
    greetd
    niri
    noctalia
    vicinae
    lockscreen
    portals
    polkit
    fcitx5
    fonts
    wlsunset
    clipboard
    brightnessctl
    xdg
    xwayland

    # Applications: Terminal & CLI
    ghostty
    neovim
    yazi
    git
    zsh
    search
    archives
    hw-tools
    monitors
    fzf
    zoxide
    trash-cli
    wiremix
    playerctl

    # Applications: Graphical (GUI)
    brave
    vscodium
    mpv
    anki
    onlyoffice
    faugus
  ];
}
