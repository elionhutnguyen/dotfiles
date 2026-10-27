{ den, lib, ... }:
{
  # 1. Declare the machine and user
  den.hosts.x86_64-linux.elio.users.elio = {
    classes = [ "homeManager" "user" ];
  };

  # 2. Apply global defaults
  den.default = {
    nixos.system.stateVersion = "25.05";
    homeManager.home.stateVersion = "25.05";

    includes = [
      den.batteries.define-user
      den.batteries.hostname
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
      (den.batteries.unfree [
        "nvidia-x11"
        "nvidia-settings"
        "onlyoffice-bin"
        "brave-browser"
      ])
    ];
  };

  # 3. Best-practice groups for power users
  den.aspects.elio.user.extraGroups = [
    "audio" "video" "input" "dialout" "libvirtd" "docker"
  ];

  # 4. Associate all aspects with the machine
  den.aspects.elio.includes = with den.aspects; [
    hardware
    core
    wayland-essentials
    fonts
    display-manager
    niri
    cli
    desktop
    i18n
  ];
}
