{ ... }:
{
  den.aspects.yazi.homeManager = { pkgs, ... }: {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
      package = pkgs.yazi.override {
        _7zz = pkgs._7zz-rar;
      };
    };

    # Localized preview and document dependencies
    home.packages = with pkgs; [
      ffmpegthumbnailer
      poppler-utils
      imagemagick
      mediainfo
      exiftool
    ];
  };
}
