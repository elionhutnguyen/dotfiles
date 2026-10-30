{ ... }:
{
  den.aspects.graphics-nvidia.nixos = { pkgs, ... }: {
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

    # NVIDIA Driver & Hybrid PRIME Configuration
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
        };
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:5:0:0";
      };
    };
  };
}
