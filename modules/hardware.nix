{ config, pkgs, ... }:

{
  # --- ASUS TUF FX505DT Battery Limit (80%) ---
  boot.kernelModules = [ "asus-nb-wmi" ];

  services.udev.extraRules = ''
    # 80% battery charge threshold, applied on plug/resume events
    ACTION=="add", SUBSYSTEM=="power_supply", KERNEL=="BAT?", ATTR{charge_control_end_threshold}="80"
  '';

  # --- NVIDIA GTX 1650 PRIME Offload ---
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    # Turing (GTX 1650): open module is supported and required for GSP-based
    # finegrained runtime D3 on driver >= 560. Flip back to false if the open
    # module misbehaves after a driver upgrade.
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    # Classic global PM off; finegrained (RTD3) below powers the dGPU down when idle.
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    prime = {
      offload = {
        enable = true;
        # Launch GUI apps on the dGPU with: prime-run <app>
        enableOffloadCmd = true;
      };
      # nixpkgs 24.11+ format: busId = "PCI slot" WITHOUT the "PCI:" prefix,
      # e.g. /sys/bus/pci/devices/0000:05:00.0 -> "5:0:0.0"
      amdgpu.busId = "5:0:0.0"; # Verify with: lspci | grep -E "VGA|3D"
      nvidia.busId = "1:0:0.0";
    };
  };

  # On-demand GPU switching daemon (replaces the old sleep_suspend.target hack,
  # which referenced a non-existent systemd target and could never work).
  # Battery savings now come from finegrained RTD3 above — no manual switching needed.
  # services.switcherooControl.enable = true;  # enable if you want runtime profile switching via `switcherooctl`

  # GPU monitoring helper
  environment.systemPackages = [ pkgs.nvtop ];
}
