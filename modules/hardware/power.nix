{ ... }:
{
  den.aspects.power.nixos = {
    # 1. System power profile states
    services.power-profiles-daemon.enable = true;

    # 2. ASUS Battery Charge Threshold (80% lifespan limit)
    boot.kernelModules = [ "asus_nb_wmi" ];

    services.udev.extraRules = ''
      ACTION=="add|change", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}!="", ATTR{charge_control_end_threshold}="80"
    '';
  };
}
