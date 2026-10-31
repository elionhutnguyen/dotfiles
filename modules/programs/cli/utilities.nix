{ ... }:
{
  den.aspects.cli-tools.homeManager = { pkgs, ... }: {
    programs.ripgrep.enable = true;
    programs.fd.enable = true;
    programs.btop.enable = true;

    home.packages = with pkgs; [
      # Archives & File Management
      _7zz-rar
      trash-cli

      # System Inspection & Monitors
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
}
