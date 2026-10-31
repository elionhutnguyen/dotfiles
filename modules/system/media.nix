{ ... }:
{
  den.aspects.media = {
    nixos = {
      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };

    homeManager = { pkgs, ... }: {
      programs.wiremix.enable = true;
      services.playerctld.enable = true;
      home.packages = [ pkgs.playerctl ];
    };
  };
}
