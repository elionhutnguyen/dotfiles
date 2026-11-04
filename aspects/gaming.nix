# aspects/gaming.nix
# Horizontal Aspect: Cross-class gaming runtime & GTK2 deprecation handler
{ ... }:
{
  den.aspects.gaming = {
    nixos = {
      hardware.graphics.enable32Bit = true;

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
