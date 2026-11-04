# modules/core/nix.nix
{ ... }:
{
  den.aspects.nix.nixos =
    { pkgs, ... }:
    {
      nixpkgs.config = {
        allowUnfree = true;
        # Unblock evaluation of transitive GTK2 dependents (e.g. nwjs / steam-run)
        # while Nixpkgs completes the 26.11 -> 27.05 GTK2 migration (#410814).
        problems.handlers = {
          "gtk+".broken = "warn";
        };
      };

      programs.nix-ld.enable = true;

      nix = {
        package = pkgs.nixVersions.latest;

        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          auto-optimise-store = true;
          trusted-users = [
            "root"
            "@wheel"
          ];
        };

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };

        optimise = {
          automatic = true;
          dates = "weekly";
        };
      };
    };
}
