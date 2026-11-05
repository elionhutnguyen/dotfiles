# aspects/gaming.nix
# Horizontal Aspect: Cross-class gaming runtime & GTK2 deprecation handler
_: {
  den.aspects.gaming = {
    nixos = {
      nixpkgs.config.problems.handlers = {
        "gtk+".broken = "warn";
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          faugus-launcher
          steam-run
          nwjs
        ];
      };
  };
}
