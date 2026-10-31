{ ... }:
{
  den.aspects.hardware.nixos = {
    # 1. Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;

    # 2. Power Profiles Daemon
    services.power-profiles-daemon.enable = true;

    # 3. ASUS Battery Charge Threshold (80% lifespan limit)
    boot.kernelModules = [ "asus_nb_wmi" ];

    systemd.tmpfiles.rules = [
      "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
    ];

    powerManagement.resumeCommands = ''
      echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold || true
    '';
  };
}
