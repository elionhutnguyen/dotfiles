# aspects/nix-daemon.nix
# Aspect: Nix daemon, NH helper, store optimisation, GC & nix-ld
_: {
  den.aspects.nix-daemon.nixos =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;

      programs = {
        nix-ld = {
          enable = true;
          libraries = with pkgs; [
            stdenv.cc.cc
            zlib
            zstd
            glib
            libGL
            openssl
          ];
        };

        nh = {
          enable = true;
          flake = "/home/elio/workspace/nix";
          clean = {
            enable = true;
            dates = "weekly";
            extraArgs = "--keep-since 7d --keep 5";
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
          use-xdg-base-directories = true;
          auto-optimise-store = true;
          keep-outputs = true;
          keep-derivations = true;
          trusted-users = [
            "root"
            "@wheel"
          ];
        };

        optimise = {
          automatic = true;
          dates = "weekly";
        };
      };
    };
}
