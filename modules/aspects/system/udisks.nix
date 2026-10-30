{ ... }:
{
  den.aspects.udisks = {
    # System storage management service
    nixos = {
      services.udisks2.enable = true;
    };

    # User-space automatic mounting daemon & tray notification
    homeManager = {
      services.udiskie = {
        enable = true;
        automount = true;
        notify = true;
        tray = "auto";
      };
    };
  };
}
