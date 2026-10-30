{ ... }:
{
  den.aspects.cardwire.nixos = {
    services.cardwired = {
      enable = true;
      settings = {
        auto_apply_gpu_state = true;
        experimental_nvidia_block = true;
        battery_auto_switch = true;
        battery_auto_switch_mode = "hybrid";
        external_display_auto_switch = true;
      };
    };

    # Required for Cardwire eBPF LSM hooks
    boot.kernelParams = [ "lsm=lockdown,yama,integrity,apparmor,bpf" ];
  };
}
