# modules/nixos/niri-system.nix
# Vertical Module: System-level Niri compositor, Greetd display manager, Noctalia & PAM
{ ... }:
{
  den.default.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.niri-system;
    in
    {
      options.my.niri-system = {
        enable = lib.mkEnableOption "system-level Niri session, Greetd tuigreet, Noctalia, and portal routing";
      };

      config = lib.mkIf cfg.enable {
        programs.niri = {
          enable = true;
          useNautilus = false;
        };

        programs.xwayland.enable = true;
        environment.systemPackages = with pkgs; [
          xwayland-satellite
          brightnessctl
          swaylock
        ];

        security.pam.services.swaylock = { };

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --cmd ${pkgs.niri}/bin/niri-session";
              user = "greeter";
            };
          };
        };

        systemd.services.greetd.serviceConfig = {
          Type = "idle";
          StandardInput = "tty";
          StandardOutput = "tty";
          StandardError = "journal";
          TTYReset = true;
          TTYVHangup = true;
          TTYVTDisallocate = true;
        };

        programs.noctalia = {
          enable = true;
          systemd.enable = true;
          recommendedServices.enable = true;
        };

        xdg.portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-gnome
          ];
          config.niri = {
            default = [
              "gnome"
              "gtk"
            ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          };
        };
      };
    };
}
