{ ... }:
{
  den.aspects.memory.nixos = {
    # 1. In-Memory Compressed Swap (High priority over physical NVMe swap)
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
      priority = 100;
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
    };

    # 2. Kernel Memory Pressure Daemon (Kills unresponsive rogue processes before OOM lockup)
    systemd.oomd = {
      enable = true;
      enableUserSlices = true;
    };
  };
}
