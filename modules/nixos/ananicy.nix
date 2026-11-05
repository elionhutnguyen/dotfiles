# modules/nixos/ananicy.nix
# Vertical Module: Ananicy-cpp process nice/scheduler auto-tuning daemon
_: {
  den.default.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.ananicy;
    in
    {
      options.my.ananicy = {
        enable = lib.mkEnableOption "ananicy-cpp process scheduler tuning with CachyOS rules";
      };

      config = lib.mkIf cfg.enable {
        services.ananicy = {
          enable = true;
          package = pkgs.ananicy-cpp;
          rulesProvider = pkgs.ananicy-rules-cachyos;
        };
      };
    };
}
