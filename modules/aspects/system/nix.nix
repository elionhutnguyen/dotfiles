{ ... }:
{
  den.aspects.nix.nixos = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;

    nix = {
      package = pkgs.nixVersions.latest;

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        trusted-users = [ "root" "@wheel" ];
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
  };
}
