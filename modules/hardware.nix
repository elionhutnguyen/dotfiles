{ config, pkgs, ... }:

let
  # 1. Battery threshold script (Clean standalone executable to satisfy udevadm)
  setBatteryLimit = pkgs.writeShellScript "set-battery-limit" ''
    for f in /sys/class/power_supply/BAT*/charge_control_end_threshold; do
      [ -f "$f" ] && echo 80 > "$f"
    done
  '';

  # 2. Dynamic GPU switcher
  autoGpu = pkgs.writeShellScriptBin "auto-gpu" ''
    if [ $# -eq 0 ]; then
      echo "Usage: auto-gpu <command> [args...]" >&2
      exit 1
    fi

    # Detect if any AC adapter is plugged in
    AC_ONLINE=0
    for ps in /sys/class/power_supply/*/online; do
      if [ -f "$ps" ] && [ "$(cat "$ps")" -eq 1 ]; then
        AC_ONLINE=1
        break
      fi
    done

    if [ "$AC_ONLINE" -eq 1 ]; then
      # On AC: Launch with dedicated NVIDIA GPU
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

  # Apply limit when battery device or WMI module is initialized
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="power_supply", KERNEL=="BAT?", ATTR{charge_control_end_threshold}="80"
    ACTION=="add", KERNEL=="asus-nb-wmi", RUN+="${setBatteryLimit}"
  '';

  # Re-apply limit upon resuming from suspend/hibernate
  powerManagement.resumeCommands = ''
    ${setBatteryLimit}
  '';

  # --- Graphics & 32-Bit Support ---
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # --- NVIDIA GTX 1650 PRIME Offload ---
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # Required for GTX 1650 (TU117 lacks open kernel module support)
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true; # RTD3 power management handles 0W idle automatically
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:5:0:0"; # Verify with: lspci | grep -E "VGA|3D"
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # System-wide packages
  environment.systemPackages = [
    autoGpu
    pkgs.ghostty # Installed system-wide
  ];
}
