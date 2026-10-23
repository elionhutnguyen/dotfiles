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
    # 1. 80% Battery threshold limit
    ACTION=="add", SUBSYSTEM=="power_supply", KERNEL=="BAT?", ATTR{charge_control_end_threshold}="80"
    ACTION=="add", KERNEL=="asus-nb-wmi", RUN+="${pkgs.bash}/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT*/charge_control_end_threshold'"

    # 2. AUTO-SWITCH: When unplugged (Battery), put NVIDIA into deep sleep (0W)
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.bash}/bin/bash -c 'echo auto > /sys/bus/pci/devices/0000:01:00.0/power/control'"

    # 3. AUTO-SWITCH: When plugged in (AC), enable hybrid offload wake-up
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.bash}/bin/bash -c 'echo auto > /sys/bus/pci/devices/0000:01:00.0/power/control'"
  '';

  systemd.services.battery-charge-threshold = {
    description = "Enforce 80% battery limit on ASUS TUF";
    wantedBy = [ "multi-user.target" "post-resume.target" ];
    after = [ "multi-user.target" "post-resume.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'for f in /sys/class/power_supply/BAT*/charge_control_end_threshold; do [ -f \"$f\" ] && echo 80 > \"$f\"; done; exit 0'";
    };
  };

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
