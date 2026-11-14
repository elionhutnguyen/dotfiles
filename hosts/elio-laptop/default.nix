# hosts/elio-laptop/default.nix
# Host Entity: Machine hardware bindings & composed system/desktop aspects
{ den, ... }:
{
  den = {
    hosts.x86_64-linux.elio-laptop = {
      users.elio = {
        classes = [
          "homeManager"
          "user"
        ];
      };
    };

    aspects.elio-laptop = {
      nixos = {
        imports = [ ./_hardware-configuration.nix ];

        boot.kernelModules = [ "asus_nb_wmi" ];

        hardware.nvidia.prime = {
          nvidiaBusId = "PCI:1:0:0";
          amdgpuBusId = "PCI:5:0:0";
        };
      };

      includes = with den.aspects; [
        system
        nix-daemon
        nvidia-prime
        power-management
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
