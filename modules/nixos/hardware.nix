{ pkgs, ... }:

let
  setBatteryLimit = pkgs.writeShellScript "set-battery-limit" ''
    for f in /sys/class/power_supply/BAT*/charge_control_end_threshold; do
      [ -f "$f" ] && echo 80 > "$f"
    done
  '';

  autoGpu = pkgs.writeShellScriptBin "auto-gpu" ''
    [ $# -eq 0 ] && { echo "Usage: auto-gpu <command> [args...]" >&2; exit 1; }
    for ps in /sys/class/power_supply/*/online; do
      [ -f "$ps" ] && [ "$(cat "$ps")" -eq 1 ] && exec nvidia-offload "$@"
    done
    exec env DRI_PRIME=0 "$@"
  '';
in
{
  # --- Power & Battery Management ---
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="power_supply", KERNEL=="BAT?", ATTR{charge_control_end_threshold}="80"
    ACTION=="add", KERNEL=="asus-nb-wmi", RUN+="${setBatteryLimit}"
  '';
  powerManagement.resumeCommands = "${setBatteryLimit}";
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # --- Graphics & Hybrid NVIDIA Offload ---
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.switcherooControl.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # GTX 1650 (TU117)
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.systemPackages = [ autoGpu ];
}
