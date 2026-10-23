{ config, pkgs, ... }:

let
  # GPU switch: hybrid (AMD iGPU + NVIDIA GTX 1650) on AC, integrated-only on battery.
  # The NVIDIA driver's sleep/suspend/hibernate services conflict with sleep_suspend.target;
  # while that target is ACTIVE the dGPU is fully powered off (battery mode), and while it is
  # INACTIVE the dGPU can run in hybrid mode with fine-grained runtime power management.
  gpuSwitch = pkgs.writeShellScriptBin "gpu-switch" ''
    AC_ONLINE=$(cat /sys/class/power_supply/AC0/online 2>/dev/null || cat /sys/class/power_supply/ADP1/online 2>/dev/null || echo 0)

    if [ "$AC_ONLINE" -eq 1 ]; then
      systemctl stop sleep_suspend.target   # power NVIDIA back on -> hybrid mode
      echo "AC detected: hybrid GPU enabled (run apps with nvidia-offload or DRI_PRIME=1)"
    else
      systemctl start sleep_suspend.target  # driver suspends -> dGPU fully off, AMD iGPU only
      echo "Battery detected: NVIDIA dGPU powered off — using integrated GPU only"
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

  # Auto-switch GPU profile when the power adapter changes (and at boot/resume)
  systemd.services.gpu-switch = {
    description = "Apply GPU power-profile based on AC/battery state";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${gpuSwitch}/bin/gpu-switch";
    };
  };

  systemd.paths.gpu-switch-start = {
    description = "Watch AC adapter state for GPU switching";
    wantedBy = [ "multi-user.target" ];
    pathConfig.GlobAcceleratePatternMatch = false;
    paths = [
      { glob = "/sys/class/power_supply/AC0/online"; }
      { glob = "/sys/class/power_supply/ADP1/online"; }
    ];
  };

  # Re-apply the profile at boot, after resume, and whenever AC state changes
  systemd.services.gpu-switch-start = {
    description = "Set GPU profile on boot and resume";
    after = [ "suspend.target" ];
    wantedBy = [ "multi-user.target" "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${gpuSwitch}/bin/gpu-switch";
    };
  };

  environment.systemPackages = [ gpuSwitch ];
}
