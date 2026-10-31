{ ... }:
{
  den.aspects.storage = {
    nixos = {
      services.udisks2.enable = true;
      services.gvfs.enable = true;
      systemd.tmpfiles.rules = [
        "d /home/data 0775 elio users -" ];
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
