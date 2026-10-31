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
    };

    homeManager = { config, pkgs, ... }:
      let
        sliceDir = "${config.home.homeDirectory}/dotfiles/modules/desktop/niri";
      in
      {
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
