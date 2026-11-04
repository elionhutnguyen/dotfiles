# modules/nixos/pipewire.nix
# Vertical Module: PipeWire low-latency audio/video routing & RTKit
{ ... }:
{
  den.default.nixos =
    { config, lib, ... }:
    let
      cfg = config.my.pipewire;
    in
    {
      options.my.pipewire = {
        enable = lib.mkEnableOption "PipeWire audio daemon with ALSA, PulseAudio, and WirePlumber";
      };

      config = lib.mkIf cfg.enable {
        security.rtkit.enable = true;

        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          wireplumber.enable = true;
        };
      };
    };
}
