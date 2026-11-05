# modules/hm/python.nix
# Vertical Module: Python 3 runtime and uv package/project manager
_: {
  den.default.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.python;
    in
    {
      options.my.python = {
        enable = lib.mkEnableOption "Python 3 runtime and uv package manager";
      };

      config = lib.mkIf cfg.enable {
        programs.uv.enable = true;
        home.packages = [ pkgs.python3 ];
      };
    };
}
