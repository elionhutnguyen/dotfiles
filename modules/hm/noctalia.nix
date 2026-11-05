# modules/hm/noctalia.nix
# Vertical Module: Noctalia v5 Wayland desktop shell, night light, polkit & idle manager
_: {
  den.default.homeManager =
    { config, lib, ... }:
    let
      cfg = config.my.noctalia;
    in
    {
      options.my.noctalia = {
        enable = lib.mkEnableOption "Noctalia v5 Wayland desktop shell";

        fontFamily = lib.mkOption {
          type = lib.types.str;
          default = "Noto Sans";
          description = "Primary UI font family for Noctalia shell surfaces.";
        };

        theme = lib.mkOption {
          type = lib.types.str;
          default = "Tokyo-Night";
          description = "Built-in Noctalia color palette name.";
        };

        nightlightEnable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable scheduled Wayland gamma night light.";
        };

        latitude = lib.mkOption {
          type = lib.types.number;
          default = 25.03;
          description = "Latitude for astronomical sunrise/sunset calculation.";
        };

        longitude = lib.mkOption {
          type = lib.types.number;
          default = 121.56;
          description = "Longitude for astronomical sunrise/sunset calculation.";
        };

        lockTimeout = lib.mkOption {
          type = lib.types.int;
          default = 300;
          description = "Idle timeout in seconds before locking the session.";
        };

        dpmsTimeout = lib.mkOption {
          type = lib.types.int;
          default = 600;
          description = "Idle timeout in seconds before powering off monitors.";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.noctalia = {
          enable = true;
          systemd.enable = true;
          checkConfig = true;
          settings = {
            shell = {
              font_family = cfg.fontFamily;
              polkit_agent = true;
              setup_wizard_enabled = false;
              telemetry_enabled = false;
              launch_apps_as_systemd_services = true;
            };
            theme = {
              mode = "dark";
              source = "builtin";
              builtin = cfg.theme;
              sync_color_scheme = true;
            };
            location = {
              auto_locate = false;
              inherit (cfg) latitude;
              inherit (cfg) longitude;
            };
            nightlight = {
              enabled = cfg.nightlightEnable;
            };
            idle = {
              behavior_order = [
                "lock"
                "screen-off"
              ];
              behavior = {
                lock = {
                  enabled = true;
                  timeout = cfg.lockTimeout;
                  action = "lock";
                };
                screen-off = {
                  enabled = true;
                  timeout = cfg.dpmsTimeout;
                  action = "screen_off";
                };
              };
            };
          };
        };
      };
    };
}
