# aspects/media.nix
# Aspect: Cross-class PipeWire audio stack, MPV & MPRIS media controls
_: {
  den.aspects.media = {
    nixos = {
      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        programs = {
          mpv = {
            enable = true;
            scripts = with pkgs.mpvScripts; [
              uosc
              sponsorblock
            ];
            config = {
              profile = "high-quality";
              vo = "gpu-next";
              hwdec = "auto-safe";
              gpu-context = "wayland";
              ytdl-format = "bestvideo+bestaudio";
              cache = "yes";
              demuxer-max-bytes = 419430400;
              demuxer-max-back-bytes = 104857600;
              keep-open = "yes";
              save-position-on-quit = true;
            };
          };

          wiremix.enable = true;
        };

        services.playerctld.enable = true;
        home.packages = [ pkgs.playerctl ];
      };
  };
}
