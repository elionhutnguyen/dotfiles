# modules/nixos/nix-daemon.nix
# Vertical Module: Nix daemon, NH helper, store optimisation, GC & nix-ld
_: {
  den.default.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.nix-daemon;
    in
    {
      options.my.nix-daemon = {
        enable = lib.mkEnableOption "declarative Nix daemon, nh helper, store optimisation, and nix-ld";

        allowUnfree = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Allow unfree packages in Nixpkgs.";
        };

        useXdgDirectories = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Force Nix CLI to use XDG base directories instead of ~/.nix-*.";
        };

        flakePath = lib.mkOption {
          type = lib.types.nullOr lib.types.singleLineStr;
          default = null;
          description = "Default flake directory exported as NH_FLAKE for `nh os` and `nh clean`.";
        };

        gcDates = lib.mkOption {
          type = lib.types.singleLineStr;
          default = "weekly";
          description = "Systemd calendar schedule for automatic NH cleanup and store optimisation.";
        };

        gcKeepSince = lib.mkOption {
          type = lib.types.singleLineStr;
          default = "7d";
          description = "Minimum age threshold for `nh clean all --keep-since`.";
        };

        gcKeepGenerations = lib.mkOption {
          type = lib.types.int;
          default = 5;
          description = "Minimum number of system/user generations always preserved by `nh clean all --keep`.";
        };
      };

      config = lib.mkIf cfg.enable {
        nixpkgs.config.allowUnfree = cfg.allowUnfree;

        programs = {
          nix-ld.enable = true;

          # NH (Nix Helper): nix-output-monitor tree + nvd package diffs + generation-safe GC
          nh = {
            enable = true;
            flake = cfg.flakePath;
            clean = {
              enable = true;
              dates = cfg.gcDates;
              extraArgs = "--keep-since ${cfg.gcKeepSince} --keep ${toString cfg.gcKeepGenerations}";
            };
          };
        };

        nix = {
          package = pkgs.nixVersions.stable;
          channel.enable = false;

          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            use-xdg-base-directories = cfg.useXdgDirectories;
            auto-optimise-store = true;
            keep-outputs = true;
            keep-derivations = true;
            trusted-users = [
              "root"
              "@wheel"
            ];
          };

          # Store hardlink deduplication (`nh.clean` handles GC; `nix.optimise` deduplicates blobs)
          optimise = {
            automatic = true;
            dates = cfg.gcDates;
          };
        };
      };
    };
}
