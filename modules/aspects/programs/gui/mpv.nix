{ ... }:
{
  den.aspects.mpv.homeManager = { config, pkgs, ... }: {
    programs.mpv = {
      enable = true;

      scripts = with pkgs.mpvScripts; [
        uosc
        sponsorblock
      ];

      config = {
        # Quality (put profile first so it isn't overridden)
        profile = "high-quality";
        vo = "gpu-next";
        hwdec = "auto-safe";

        # Wayland (remove if X11)
        gpu-context = "wayland";

        # Streaming
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;

        # Behavior
        keep-open = "yes";
        save-position-on-quit = true;
      };
    };
  };
}
