# modules/nixos/nix-daemon.nix
# Vertical Module: Nix daemon, store optimisation, garbage collection & nix-ld
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
      cfg = config.my.nix-daemon;
    in
    {
      options.my.nix-daemon = {
        enable = lib.mkEnableOption "declarative Nix daemon, store optimisation, GC, and nix-ld";

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

        gcDates = lib.mkOption {
          type = lib.types.str;
          default = "weekly";
          description = "Systemd calendar schedule for automatic Nix garbage collection.";
        };

        gcDeleteOlderThan = lib.mkOption {
          type = lib.types.str;
          default = "7d";
          description = "Retention window for Nix store generations during GC.";
        };
      };

      config = lib.mkIf cfg.enable {
        nixpkgs.config.allowUnfree = cfg.allowUnfree;

        programs.nix-ld.enable = true;

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
            trusted-users = [
              "root"
              "@wheel"
            ];
          };

          gc = {
            automatic = true;
            dates = cfg.gcDates;
            options = "--delete-older-than ${cfg.gcDeleteOlderThan}";
          };

          optimise = {
            automatic = true;
            dates = cfg.gcDates;
          };
        };
      };
    };
}
