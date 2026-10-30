{ ... }:
{
  den.aspects.battery-charge-limit.nixos = {
    boot.kernelModules = [ "asus_nb_wmi" ];

    # Set 80% threshold on boot
    systemd.tmpfiles.rules = [
      "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
    ];

    # Re-apply 80% threshold upon waking from suspend
    powerManagement.resumeCommands = ''
      echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold || true
    '';
  };
}
