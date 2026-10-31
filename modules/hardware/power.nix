{ ... }:
{
  den.aspects.power.nixos = {
    # 1. System power profile states
    services.power-profiles-daemon.enable = true;

    # 2. ASUS Battery Charge Threshold (80% lifespan limit)
    boot.kernelModules = [ "asus_nb_wmi" ];

    systemd.tmpfiles.rules = [
      "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
    ];

    powerManagement.resumeCommands = ''
      echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold || true
    '';
  };
}
