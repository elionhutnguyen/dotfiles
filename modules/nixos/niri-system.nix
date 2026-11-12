# modules/nixos/niri-system.nix
# Vertical Module: System-level Niri compositor, Greetd display manager & portal override
_: {
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
        enable = lib.mkEnableOption "system-level Niri session, Greetd tuigreet, and portal routing";
      };

      config = lib.mkIf cfg.enable {
        programs.niri = {
          enable = true;
          useNautilus = false;
        };

        environment.systemPackages = [ pkgs.xwayland-satellite ];

        security.pam.services.greetd.enableGnomeKeyring = true;

        services = {
          gnome = {
            gnome-keyring.enable = true;
            gcr-ssh-agent.enable = false;
          };

          greetd = {
            enable = true;
            settings = {
              default_session = {
                command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-user-session --asterisks --cmd ${lib.getExe' config.programs.niri.package "niri-session"}";
                user = "greeter";
              };
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

        xdg.portal.config.niri."org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
}
