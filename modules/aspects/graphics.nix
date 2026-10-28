{ ... }:
{
  den.aspects.graphics.nixos = { pkgs, ... }: {
    hardware.enableRedistributableFirmware = true;

    # Mesa / VA-API Acceleration
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    # NVIDIA Driver & Hybrid PRIME Offload
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true; # D3Cold sleep on battery
      open = false;
      nvidiaSettings = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true; # Creates 'nvidia-offload' wrapper
        };
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:5:0:0";
      };
    };

    # Dynamic GPU power control via udev
    services.udev.extraRules = ''
      SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{device}=="0x1f99", ATTR{power/control}="auto"
    '';
  };
}
