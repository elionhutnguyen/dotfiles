# modules/programs/cli/cli-tools.nix
{ ... }:
{
  den.aspects.cli-tools.homeManager =
    { pkgs, ... }:
    {
      programs.ripgrep.enable = true;
      programs.fd.enable = true;
      programs.btop.enable = true;

      home.packages = with pkgs; [
        uv
        python3
        trash-cli

        # System Inspection & Monitors
        libva-utils
        vdpauinfo
        pciutils
        usbutils
        nvtopPackages.full
      ];
    };
}
