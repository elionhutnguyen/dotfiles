# modules/hm/yazi.nix
# Vertical Module: Yazi terminal file manager & rich media previewers
{ ... }:
{
  den.default.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.yazi;
    in
    {
      options.my.yazi = {
        enable = lib.mkEnableOption "Yazi terminal file manager and previewer toolchain";

        shellWrapperName = lib.mkOption {
          type = lib.types.str;
          default = "y";
          description = "Zsh shell wrapper function name for directory changing on exit.";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.yazi = {
          enable = true;
          enableZshIntegration = true;
          shellWrapperName = cfg.shellWrapperName;
          package = pkgs.yazi.override {
            _7zz = pkgs._7zz-rar;
          };
        };

        home.packages = with pkgs; [
          ffmpegthumbnailer
          poppler-utils
          imagemagick
          mediainfo
          exiftool
        ];
      };
    };
}
