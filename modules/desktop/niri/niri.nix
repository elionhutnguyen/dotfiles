{ ... }:
{
  den.aspects.niri = {
    nixos = { pkgs, ... }: {
      programs.niri = {
        enable = true;
        useNautilus = false;
      };

      # XWayland satellite daemon
      programs.xwayland.enable = true;
      environment.systemPackages = [
        pkgs.xwayland-satellite
        pkgs.brightnessctl
        pkgs.swaylock
      ];

      # PAM authentication for swaylock
      security.pam.services.swaylock = {};

      # Display manager session definition
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

      # Shell daemon for Niri
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        recommendedServices.enable = true;
      };

      # Portal routing for Niri session
      xdg.portal.config.niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };

    homeManager = { config, pkgs, ... }:
      let
        sliceDir = "${config.home.homeDirectory}/dotfiles/modules/desktop/niri";
      in
      {
        # Integrated launcher for Niri
        programs.vicinae = {
          enable = true;
          systemd.enable = true;
        };

        # Swayidle integration
        services.swayidle = {
          enable = true;
          timeouts = [
            {
              timeout = 300;
              command = "${pkgs.swaylock}/bin/swaylock -f";
            }
            {
              timeout = 600;
              command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
            }
          ];
          events = {
            before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
            lock = "${pkgs.swaylock}/bin/swaylock -f";
          };
        };

        # Wayland Night Light (Taipei Coordinates)
        services.wlsunset = {
          enable = true;
          latitude = "25.03";
          longitude = "121.56";
        };

        # Out-of-store config symlink
        xdg.configFile."niri".source =
          config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
      };
  };
}
