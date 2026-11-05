# modules/nixos/system-base.nix
# Vertical Module: Core kernel, bootloader, zram, VM sysctl, oomd & journald caps
_: {
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

        swappiness = lib.mkOption {
          type = lib.types.ints.between 0 200;
          default = 100;
          description = "Kernel vm.swappiness value (100 balances zram with physical NVMe swap).";
        };

        journalMaxUse = lib.mkOption {
          type = lib.types.str;
          default = "500M";
          description = "Maximum disk space used by persistent systemd-journald logs.";
        };
      };

      config = lib.mkIf cfg.enable {
        boot = {
          inherit (cfg) kernelPackages;
          loader = {
            systemd-boot = {
              enable = true;
              inherit (cfg) configurationLimit;
            };
            efi.canTouchEfiVariables = true;
          };
          tmp = {
            useTmpfs = true;
            tmpfsSize = "50%";
            cleanOnBoot = false;
          };
          kernel.sysctl = {
            "vm.swappiness" = cfg.swappiness;
            "vm.page-cluster" = 0;
          };
        };

        systemd = {
          coredump.enable = false;
          oomd = {
            enable = true;
            enableUserSlices = false;
          };
        };

        zramSwap = {
          enable = true;
          algorithm = "zstd";
          memoryPercent = cfg.zramPercent;
          priority = 100;
        };

        services = {
          fstrim.enable = true;
          fwupd.enable = true;
          journald.settings.Journal = {
            SystemMaxUse = cfg.journalMaxUse;
            SystemMaxFiles = 5;
          };
        };
      };
    };
}
