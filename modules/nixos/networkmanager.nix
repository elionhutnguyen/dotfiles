# modules/nixos/networkmanager.nix
# Vertical Module: NetworkManager system daemon
{ ... }:
{
  den.default.nixos =
    { config, lib, ... }:
    let
      cfg = config.my.networkmanager;
    in
    {
      options.my.networkmanager = {
        enable = lib.mkEnableOption "NetworkManager connectivity daemon";
      };

      config = lib.mkIf cfg.enable {
        networking.networkmanager.enable = true;
      };
    };
}
