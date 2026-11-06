# modules/hm/cli-tools.nix
# Vertical Module: Core CLI search, system monitor, Nix static analysis, and trash utilities
_: {
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

        enableHwDiag = lib.mkEnableOption "hardware and GPU diagnostic tools (nvtop, vainfo, vdpauinfo, lspci, lsusb)";

        btopTheme = lib.mkOption {
          type = lib.types.str;
          default = "tokyo-night";
          description = "Color theme for btop.";
        };
      };

      config = lib.mkIf cfg.enable {
        programs = {
          ripgrep.enable = true;
          fd.enable = true;
          btop = {
            enable = true;
            settings.color_theme = cfg.btopTheme;
          };
          direnv = {
            enable = true;
            nix-direnv.enable = true;
          };
        };

        home.packages =
          (with pkgs; [
            trash-cli

            # Deterministic Nix formatters & linters for zero-token agent verification
            nixfmt
            statix
            deadnix
          ])
          ++ lib.optionals cfg.enableHwDiag (
            with pkgs;
            [
              libva-utils
              vdpauinfo
              pciutils
              usbutils
              nvtopPackages.full
            ]
          );
      };
    };
}
