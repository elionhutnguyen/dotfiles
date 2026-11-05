# modules/hm/hw-diag.nix
# Vertical Module: GPU, VAAPI/VDPAU, PCI, and USB hardware inspection tools
_: {
  den.default.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.hw-diag;
    in
    {
      options.my.hw-diag = {
        enable = lib.mkEnableOption "hardware and GPU diagnostic tools (nvtop, vainfo, vdpauinfo, lspci, lsusb)";
      };

      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          libva-utils
          vdpauinfo
          pciutils
          usbutils
          nvtopPackages.full
        ];
      };
    };
}
