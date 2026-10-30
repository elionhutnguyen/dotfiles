{ ... }:
{
  den.aspects.cardwire.nixos = {
    services.cardwired = {
      enable = true;
      settings = {
        battery_auto_switch = true;
        battery_auto_switch_mode = "hybrid";
      };
    };

    # Required for Cardwire eBPF LSM hooks
    boot.kernelParams = [ "lsm=lockdown,yama,integrity,apparmor,bpf" ];
  };
}
