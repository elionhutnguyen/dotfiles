# aspects/system.nix
# Aspect: Core kernel, bootloader, zram, sysctl, oomd, journald, NetworkManager, Bluetooth & Ananicy
_: {
  den.aspects.system.nixos =
    { pkgs, ... }:
    {
      boot = {
        kernelPackages = pkgs.linuxPackages;
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 10;
          };
          efi.canTouchEfiVariables = true;
        };
        tmp = {
          useTmpfs = true;
          tmpfsSize = "50%";
          cleanOnBoot = false;
        };
        kernel.sysctl = {
          "vm.swappiness" = 100;
          "vm.page-cluster" = 0;
        };
      };

      networking = {
        networkmanager = {
          enable = true;
          wifi = {
            powersave = false;
            scanRandMacAddress = false;
          };
        };
        firewall.extraInputRules = ''
          iifname { "wl*", "ap*" } udp dport { 53, 67 } accept
          iifname { "wl*", "ap*" } tcp dport 53 accept
        '';
      };

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
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
        memoryPercent = 50;
        priority = 100;
      };

      services = {
        fstrim.enable = true;
        fwupd.enable = true;
        resolved = {
          enable = true;
          settings.Resolve = {
            FallbackDNS = [
              "1.1.1.1"
              "8.8.8.8"
            ];
            DNSOverTLS = "opportunistic";
          };
        };
        journald.settings.Journal = {
          SystemMaxUse = "500M";
          SystemMaxFiles = 5;
        };
        ananicy = {
          enable = true;
          package = pkgs.ananicy-cpp;
          rulesProvider = pkgs.ananicy-rules-cachyos;
        };
      };
    };
}
