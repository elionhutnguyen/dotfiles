# aspects/nvidia-prime.nix
# Aspect: NVIDIA PRIME offload, VAAPI acceleration & cardwired eBPF switching
_: {
  den.aspects.nvidia-prime.nixos =
    { pkgs, ... }:
    {
      hardware = {
        enableRedistributableFirmware = true;

        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            nvidia-vaapi-driver
          ];
        };

        nvidia = {
          modesetting.enable = true;
          powerManagement = {
            enable = true;
            finegrained = true;
          };
          open = true;

          prime.offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        };
      };

      services = {
        xserver.videoDrivers = [ "nvidia" ];

        cardwired = {
          enable = true;
          settings = {
            auto_apply_gpu_state = true;
            experimental_nvidia_block = false;
            battery_auto_switch = true;
            battery_auto_switch_mode = "hybrid";
            external_display_auto_switch = true;
          };
        };
      };

      boot.kernelParams = [
        "lsm=landlock,lockdown,yama,integrity,apparmor,bpf"
      ];
    };
}
