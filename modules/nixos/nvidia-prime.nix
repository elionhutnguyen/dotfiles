# modules/nixos/nvidia-prime.nix
# Vertical Module: NVIDIA PRIME offload, VAAPI acceleration & cardwired eBPF switching
_: {
  den.default.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.nvidia-prime;
    in
    {
      options.my.nvidia-prime = {
        enable = lib.mkEnableOption "NVIDIA PRIME offload and dynamic GPU power management";

        nvidiaBusId = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "PCI Bus ID of the discrete NVIDIA GPU (e.g. PCI:1:0:0).";
        };

        amdgpuBusId = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "PCI Bus ID of the integrated AMD GPU (e.g. PCI:5:0:0).";
        };

        intelBusId = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "PCI Bus ID of the integrated Intel GPU.";
        };

        open = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Use the open-source NVIDIA kernel modules.";
        };

        cardwiredEnable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable cardwired dynamic GPU power switching & eBPF hooks.";
        };
      };

      config = lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = cfg.nvidiaBusId != "" && (cfg.amdgpuBusId != "" || cfg.intelBusId != "");
            message = "my.nvidia-prime requires `nvidiaBusId` and either `amdgpuBusId` or `intelBusId` to be set.";
          }
        ];

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
            powerManagement.enable = true;
            powerManagement.finegrained = true;
            inherit (cfg) open;
            nvidiaSettings = true;

            prime = {
              offload.enable = true;
              offload.enableOffloadCmd = true;
              inherit (cfg) nvidiaBusId;
              amdgpuBusId = lib.mkIf (cfg.amdgpuBusId != "") cfg.amdgpuBusId;
              intelBusId = lib.mkIf (cfg.intelBusId != "") cfg.intelBusId;
            };
          };
        };

        services.xserver.videoDrivers = [ "nvidia" ];

        services.cardwired = lib.mkIf cfg.cardwiredEnable {
          enable = true;
          settings = {
            auto_apply_gpu_state = true;
            experimental_nvidia_block = true;
            battery_auto_switch = true;
            battery_auto_switch_mode = "hybrid";
            external_display_auto_switch = true;
          };
        };

        boot.kernelParams = lib.mkIf cfg.cardwiredEnable [
          "lsm=landlock,lockdown,yama,integrity,apparmor,bpf"
        ];
      };
    };
}
