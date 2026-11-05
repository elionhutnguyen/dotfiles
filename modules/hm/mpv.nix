# modules/hm/mpv.nix
# Vertical Module: GPU-next Wayland MPV media player with uosc & sponsorblock
_: {
  den.default.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.mpv;
    in
    {
      options.my.mpv = {
        enable = lib.mkEnableOption "hardware-accelerated Wayland MPV media player";
      };

      config = lib.mkIf cfg.enable {
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
            demuxer-max-bytes = 419430400;
            demuxer-max-back-bytes = 104857600;
            keep-open = "yes";
            save-position-on-quit = true;
          };
        };
      };
    };
}
