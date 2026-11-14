# aspects/power-management.nix
# Aspect: Power profiles daemon & laptop battery charge threshold udev control
_: {
  den.aspects.power-management.nixos = {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
      udev.extraRules = ''
        ACTION=="add|change", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}!="", ATTR{charge_control_end_threshold}="80"
      '';
    };
  };
}
