{ ... }:
{
  den.aspects.power.nixos = {
    # 1. System power profile states (performance, balanced, power-saver)
    services.power-profiles-daemon.enable = true;

    # 2. Hardware Battery Charge Threshold (80% lifespan protection)
    boot.kernelModules = [ "asus_nb_wmi" ];

    systemd.tmpfiles.rules = [
      "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
    ];

    powerManagement.resumeCommands = ''
      echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold || true
    '';
  };
}
