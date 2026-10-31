{ ... }:
{
  den.aspects.nvidia.nixos = { pkgs, ... }: {
    hardware.enableRedistributableFirmware = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = false;
      nvidiaSettings = true;

      prime = {
        offload.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:5:0:0";
      };
    };

    # Cardwire dynamic GPU power switching & eBPF hooks
    services.cardwired = {
      enable = true;
      settings = {
        auto_apply_gpu_state = true;
        experimental_nvidia_block = true;
        battery_auto_switch = true;
        battery_auto_switch_mode = "hybrid";
        external_display_auto_switch = true;
      };
    };
    boot.kernelParams = [ "lsm=landlock,lockdown,yama,integrity,apparmor,bpf" ];
  };
}
