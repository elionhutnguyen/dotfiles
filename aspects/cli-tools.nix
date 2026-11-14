# aspects/cli-tools.nix
# Aspect: Core CLI search, Yazi file manager, system monitor, Nix linters & hardware diagnostics
_: {
  den.aspects.cli-tools.homeManager =
    { pkgs, ... }:
    {
      programs = {
        ripgrep.enable = true;
        fd.enable = true;
        btop.enable = true;
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        yazi = {
          enable = true;
          shellWrapperName = "y";
          package = pkgs.yazi.override {
            _7zz = pkgs._7zz-rar;
          };
        };
      };

      home.packages = with pkgs; [
        trash-cli

        # Deterministic Nix formatters & linters
        nixfmt
        statix
        deadnix

        # Hardware & GPU diagnostics
        libva-utils
        vdpauinfo
        pciutils
        usbutils
        nvtopPackages.full

        # Yazi rich media previewers
        ffmpegthumbnailer
        poppler-utils
        imagemagick
        mediainfo
        exiftool
      ];
    };
}
