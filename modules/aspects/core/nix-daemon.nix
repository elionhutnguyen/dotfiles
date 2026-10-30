{ ... }:
{
  den.aspects.nix-daemon.nixos = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;

    nix = {
      package = pkgs.nixVersions.latest;

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
  };
}
