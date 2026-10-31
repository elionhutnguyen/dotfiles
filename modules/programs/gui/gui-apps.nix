{ ... }:
{
  den.aspects.gui-apps.homeManager = { pkgs, ... }: {
    # 1. Standalone Packages
    home.packages = with pkgs; [
      brave-origin
      faugus-launcher
    ];

    # 2. Managed GUI Programs
    programs.vscodium.enable = true;
    programs.onlyoffice.enable = true;

    programs.anki = {
      enable = true;
      addons = with pkgs.ankiAddons; [
        passfail2
        review-heatmap
      ];
    };

    programs.mpv = {
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
	demuxer-max-bytes = 419430400; # 400 MiB buffer
	demuxer-max-back-bytes = 104857600; # 100 MiB backward buffer
        keep-open = "yes";
        save-position-on-quit = true;
      };
    };
  };
}
