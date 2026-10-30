{ ... }:
{
  den.aspects.zram.nixos = {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
      priority = 5;
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = 100;
    };
  };
}
