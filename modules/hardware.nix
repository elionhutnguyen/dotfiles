{ config, pkgs, ... }:

let
  # Smart launcher: automatically evaluates power source before running apps
  autoGpu = pkgs.writeShellScriptBin "auto-gpu" ''
    AC_ONLINE=$(cat /sys/class/power_supply/AC0/online 2>/dev/null || cat /sys/class/power_supply/ADP1/online 2>/dev/null || echo 0)

    if [ "$AC_ONLINE" -eq 1 ]; then
      # On AC: Run with NVIDIA PRIME Offload
      exec nvidia-offload "$@"
    else
      # On Battery: Silently route to energy-efficient AMD iGPU
      exec env DRI_PRIME=0 "$@"
    fi
  '';
in
{
  # --- ASUS TUF FX505DT Battery Limit (80%) ---
  boot.kernelModules = [ "asus-nb-wmi" ];

  services.udev.extraRules = ''
    # 80% battery charge threshold, applied on plug/resume events
    ACTION=="add", SUBSYSTEM=="power_supply", KERNEL=="BAT?", ATTR{charge_control_end_threshold}="80"
  '';

  # --- NVIDIA GTX 1650 PRIME Offload ---
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true; # PCIe Runtime D3 power management
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:5:0:0"; # Verify with: lspci | grep -E "VGA|3D"
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.systemPackages = [ autoGpu ];
}
