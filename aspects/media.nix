# aspects/media.nix
# Horizontal Aspect: Cross-class PipeWire audio stack & MPRIS media controls
_: {
  den.aspects.media = {
    nixos = {
      my.pipewire.enable = true;
    };

    homeManager =
      { pkgs, ... }:
      {
        programs.wiremix.enable = true;
        services.playerctld.enable = true;
        home.packages = [ pkgs.playerctl ];
      };
  };
}
