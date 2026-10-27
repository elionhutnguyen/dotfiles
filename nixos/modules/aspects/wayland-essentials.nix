{ pkgs, ... }:
{
  den.aspects.wayland-essentials.nixos = {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
    security.polkit.enable = true;
    programs.dconf.enable = true;

    xdg.portal = {
      enable = true;
      config.niri.default = [ "gnome" "gtk" ];
      extraPortals = with pkgs; [ xdg-desktop-portal-gnome xdg-desktop-portal-gtk ];
    };

    environment.systemPackages = with pkgs; [
      polkit_gnome
      wl-clipboard
    ];
  };

  den.aspects.wayland-essentials.homeManager = { pkgs, ... }: {
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        WantedBy = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
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
}
