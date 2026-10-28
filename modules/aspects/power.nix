{ ... }:
{
  den.aspects.power.nixos = {
    boot.kernelModules = [ "asus_nb_wmi" ];
    services.power-profiles-daemon.enable = true;

    # 80% Battery threshold on boot
    systemd.tmpfiles.rules = [
      "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
    ];

    # Re-apply 80% limit when waking from suspend
    powerManagement.resumeCommands = ''
      echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold || true
    '';
  };
}
