# modules/nixos/system-base.nix
# Vertical Module: Core kernel, bootloader, zram, VM sysctl, oomd & journald caps
{ ... }:
{
  den.default.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.system-base;
    in
    {
      options.my.system-base = {
        enable = lib.mkEnableOption "core NixOS kernel, systemd-boot, zram, oomd, and maintenance baseline";

        kernelPackages = lib.mkOption {
          type = lib.types.raw;
          default = pkgs.linuxPackages;
          defaultText = lib.literalExpression "pkgs.linuxPackages";
          description = "Linux kernel package set (defaults to Hydra-tested LTS kernel for NVIDIA/eBPF stability).";
        };

        configurationLimit = lib.mkOption {
          type = lib.types.int;
          default = 10;
          description = "Maximum number of boot generations kept in systemd-boot.";
        };

        zramPercent = lib.mkOption {
          type = lib.types.int;
          default = 50;
          description = "Percentage of RAM allocated to zstd zram swap.";
        };

        journalMaxUse = lib.mkOption {
          type = lib.types.str;
          default = "500M";
          description = "Maximum disk space used by persistent systemd-journald logs.";
        };
      };

      config = lib.mkIf cfg.enable {
        boot.kernelPackages = cfg.kernelPackages;
        boot.loader.systemd-boot = {
          enable = true;
          configurationLimit = cfg.configurationLimit;
        };
        boot.loader.efi.canTouchEfiVariables = true;

        boot.tmp = {
          useTmpfs = true;
          tmpfsSize = "50%";
          cleanOnBoot = false;
        };

        systemd.coredump.enable = false;

        zramSwap = {
          enable = true;
          algorithm = "zstd";
          memoryPercent = cfg.zramPercent;
          priority = 100;
        };

        boot.kernel.sysctl = {
          "vm.swappiness" = 180;
          "vm.page-cluster" = 0;
        };

        systemd.oomd = {
          enable = true;
          enableUserSlices = false;
        };

        services.fstrim.enable = true;
        services.fwupd.enable = true;

        services.journald.settings.Journal = {
          SystemMaxUse = cfg.journalMaxUse;
          SystemMaxFiles = 5;
        };
      };
    };
}
