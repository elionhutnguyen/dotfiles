{ ... }:
{
  den.aspects.wayland-services = {
    nixos = { pkgs, ... }: {
      environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.greetd.enableGnomeKeyring = true;
      programs.dconf.enable = true;

      xdg.portal = {
        enable = true;
        config.niri.default = [ "gnome" "gtk" ];
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
      };

      environment.systemPackages = [ pkgs.wl-clipboard ];
    };

    homeManager = { pkgs, ... }: {
      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        Unit = {
          Description = "polkit-gnome-authentication-agent-1";
          Wants = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
