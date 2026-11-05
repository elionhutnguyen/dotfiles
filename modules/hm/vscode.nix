# modules/hm/vscode.nix
# Vertical Module: VSCode editor with zero-token Supermaven inline completion
_: {
  den.default.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.vscode;
    in
    {
      options.my.vscode = {
        enable = lib.mkEnableOption "VSCode editor with Supermaven inline completion";

        extraExtensions = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Additional VSCode extensions to install in the default profile.";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.vscode = {
          enable = true;
          profiles.default = {
            extensions =
              with pkgs.vscode-extensions;
              [
                supermaven.supermaven
              ]
              ++ cfg.extraExtensions;
          };
        };
      };
    };
}
