{ ... }:
{
  den.aspects.storage = {
    nixos = {
      services.udisks2.enable = true;
      services.gvfs.enable = true;
    };

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
