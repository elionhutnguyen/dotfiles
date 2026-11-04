# aspects/desktop.nix
# Horizontal Aspect: Multi-class Wayland desktop glue (Niri, Fcitx5, Portals, Keyring, Polkit)
{ ... }:
{
  den.aspects.desktop = {
    nixos =
      { pkgs, ... }:
      {
        # Enable system-level Niri vertical module
        my.niri-system.enable = true;

        # Input Method (fcitx5)
        i18n.inputMethod = {
          enable = true;
          type = "fcitx5";
          fcitx5 = {
            waylandFrontend = true;
            addons = with pkgs; [
              fcitx5-bamboo
              qt6Packages.fcitx5-chinese-addons
              qt6Packages.fcitx5-configtool
              fcitx5-gtk
            ];
          };
        };

        # Fallback Desktop Portal Policy
        xdg.portal = {
          enable = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          config.common.default = [ "gtk" ];
        };

        # Keyring + PAM Auto-Unlock, Dconf, Polkit & Wayland Ozone Environment
        services.gnome.gnome-keyring.enable = true;
        security.pam.services.greetd.enableGnomeKeyring = true;
        programs.dconf.enable = true;
        security.polkit.enable = true;
        environment.systemPackages = [ pkgs.wl-clipboard ];
        environment.sessionVariables = {
          NIXOS_OZONE_WL = "1";
        };
      };

    homeManager =
      { pkgs, ... }:
      {
        # Enable user-level Niri vertical module & push session default binaries
        my.niri = {
          enable = true;
          terminal = "ghostty";
          launcher = "vicinae";
          fileManager = "yazi";
          screenLocker = "swaylock";
        };

        # Polkit GNOME Authentication Agent
        systemd.user.services.polkit-gnome-authentication-agent-1 = {
          Unit = {
            Description = "polkit-gnome-authentication-agent-1";
            PartOf = [ "graphical-session.target" ];
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
