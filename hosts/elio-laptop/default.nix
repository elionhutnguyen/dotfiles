# hosts/elio-laptop/default.nix
# Host Composition: Thin machine declaration enabling vertical hardware/system modules & horizontal aspects
{ den, ... }:
{
  # 1. Host & User Entity Topology
  den.hosts.x86_64-linux.elio-laptop = {
    users.elio = {
      classes = [
        "homeManager"
        "user"
      ];
    };
  };

  # 2. Enable & Parameterize Vertical NixOS Modules Directly
  den.aspects.elio-laptop.nixos = {
    imports = [ ./_hardware-configuration.nix ];

    # Core System Vertical Modules
    my.nix-daemon.enable = true;
    my.system-base.enable = true;
    my.networkmanager.enable = true;
    my.ananicy.enable = true;
    my.bluetooth.enable = true;

    # Hardware Vertical Modules (with machine-specific bus IDs & WMI modules)
    my.nvidia-prime = {
      enable = true;
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:5:0:0";
    };

    my.power-management = {
      enable = true;
      maxChargePercent = 80;
      extraKernelModules = [ "asus_nb_wmi" ];
    };

    # Host-specific data partition permissions
    systemd.tmpfiles.rules = [
      "d /home/data 0775 elio users -"
      "z /home/data 0775 elio users -"
    ];
  };

  # 3. Include Genuine Horizontal Aspects + Primary User Aspect
  den.aspects.elio-laptop.includes = with den.aspects; [
    locale
    storage
    media
    xdg
    theming
    desktop
    elio
  ];
}
