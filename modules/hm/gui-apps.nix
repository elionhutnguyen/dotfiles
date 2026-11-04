# modules/hm/gui-apps.nix
# Vertical Module: Desktop productivity, browser, messaging & office applications
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
      cfg = config.my.gui-apps;
    in
    {
      options.my.gui-apps = {
        enable = lib.mkEnableOption "Anki, Brave Origin, Materialgram, and OnlyOffice";
      };

      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          anki-bin
          brave-origin
          materialgram
        ];

        programs.onlyoffice.enable = true;
      };
    };
}
