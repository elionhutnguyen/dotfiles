# hosts/elio-laptop/default.nix
# Host Composition: Thin machine declaration enabling vertical hardware/system modules & horizontal aspects
{ den, ... }:
{
  den = {
    # 1. Host & User Entity Topology
    hosts.x86_64-linux.elio-laptop = {
      users.elio = {
        classes = [
          "homeManager"
          "user"
        ];
      };
    };

    # 2. Enable & Parameterize Vertical NixOS Modules Directly + Include Horizontal Aspects
    aspects.elio-laptop = {
      nixos = {
        imports = [ ./_hardware-configuration.nix ];

        my = {
          # Core System Vertical Modules
          nix-daemon = {
            enable = true;
            flakePath = "/home/elio/workspace/nix";
          };
          system-base.enable = true;
          networkmanager.enable = true;
          ananicy.enable = true;
          bluetooth.enable = true;

          # Hardware Vertical Modules (with machine-specific bus IDs & WMI modules)
          nvidia-prime = {
            enable = true;
            nvidiaBusId = "PCI:1:0:0";
            amdgpuBusId = "PCI:5:0:0";
          };

          power-management = {
            enable = true;
            maxChargePercent = 80;
            extraKernelModules = [ "asus_nb_wmi" ];
          };
        };
      };

      # 3. Include Genuine Horizontal Aspects
      includes = with den.aspects; [
        locale
        storage
        media
        xdg
        theming
        desktop
      ];
    };
  };
}
