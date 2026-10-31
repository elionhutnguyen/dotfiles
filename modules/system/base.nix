{ ... }:
{
  den.aspects.base.nixos = { pkgs, ... }: {
    # 1. Kernel & Bootloader
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.tmp.cleanOnBoot = true;
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    boot.loader.efi.canTouchEfiVariables = true;

    # 2. Memory & Swap Management
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

    systemd.oomd = {
      enable = true;
      enableUserSlices = true;
    };

    # 3. System Maintenance Daemons
    services.fstrim.enable = true;
    services.fwupd.enable = true;

    # 4. Journald log caps
    services.journald.settings.Journal = {
      SystemMaxUse = "500M";
      SystemMaxFiles = 5;
    };
  };
}
