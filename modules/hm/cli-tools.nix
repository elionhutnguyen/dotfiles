# modules/hm/cli-tools.nix
# Vertical Module: Core CLI search, system monitor, Nix static analysis, and trash utilities
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
      cfg = config.my.cli-tools;
    in
    {
      options.my.cli-tools = {
        enable = lib.mkEnableOption "core CLI search utilities (ripgrep, fd), Nix linters, btop, and trash-cli";

        btopTheme = lib.mkOption {
          type = lib.types.str;
          default = "tokyo-night";
          description = "Color theme for btop.";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.ripgrep.enable = true;
        programs.fd.enable = true;
        programs.btop = {
          enable = true;
          settings.color_theme = cfg.btopTheme;
        };
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          enableZshIntegration = true;
        };

        home.packages = with pkgs; [
          trash-cli

          # Deterministic Nix formatters & linters for zero-token agent verification
          nixfmt
          statix
          deadnix
        ];
      };
    };
}
