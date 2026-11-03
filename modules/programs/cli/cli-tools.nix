{ ... }:
{
  den.aspects.cli-tools = { 
    nixos = {
      programs.git.enable = true;
    };
    homeManager = { pkgs, ... }: {
      programs.ripgrep.enable = true;
      programs.fd.enable = true;
      programs.btop.enable = true;

      home.packages = with pkgs; [
        uv
        python3
        # Archives & File Management
        _7zz-rar
        trash-cli

        # System Inspection & Monitors
        libva-utils
        vdpauinfo
        pciutils
        usbutils
        nvtopPackages.full

        # Yazi Terminal Media & Document Previews
        ffmpegthumbnailer
        poppler-utils
        imagemagick
        mediainfo
        exiftool
      ];
    };
  };
}
