{ ... }:
{
  den.aspects.desktop-env = {
    nixos = { pkgs, ... }: {
      # 1. Fonts
      fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-color-emoji
          nerd-fonts.jetbrains-mono
        ];
        fontconfig.defaultFonts = {
          serif = [ "Noto Serif" "Noto Serif CJK TC" "Noto Serif CJK SC" ];
          sansSerif = [ "Noto Sans" "Noto Sans CJK TC" "Noto Sans CJK SC" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };

      # 2. Input Method (fcitx5)
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

      # 3. Portals & Desktop Integration
      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-gtk
        ];
        config = {
          niri = {
            default = [ "gnome" "gtk" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          };
          common = {
            default = [ "gtk" ];
          };
        };
      };

      services.gnome.gnome-keyring.enable = true;
      security.pam.services.greetd.enableGnomeKeyring = true;
      programs.dconf.enable = true;
      environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

      # 4. Polkit & Clipboard
      security.polkit.enable = true;
      environment.systemPackages = [ pkgs.wl-clipboard ];
    };

    homeManager = { config, pkgs, ... }: {
      # Polkit Authentication Agent
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

      # Standard XDG Dirs
      xdg.userDirs = {
        enable = true;
        createDirectories = false;
        download = "${config.home.homeDirectory}/Downloads";
        setSessionVariables = false;
      };
    };
  };
}
