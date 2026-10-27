{ ... }:
{
  den.aspects.hardware.nixos = { pkgs, ... }: {
    imports = [ ../_hardware-configuration.nix ];

    boot.kernelModules = [ "asus_nb_wmi" ];
    # 1. 80% Battery Threshold (Applies on boot)
    systemd.tmpfiles.rules = [
      "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
    ];

    # Apply 80% limit when waking up from suspend
    powerManagement.resumeCommands = ''
      echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold || true
    '';

    # 2. Graphics & Power Profiles
    services.power-profiles-daemon.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ libva-vdpau-driver libvdpau-va-gl ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true; # D3Cold suspension on battery
      open = false;
      nvidiaSettings = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:5:0:0";
      };
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
    };

    # 3. Dynamic Power State Management via Udev
    services.udev.extraRules = ''
      SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{device}=="0x1f99", ATTR{power/control}="auto"
    '';
  };
}
