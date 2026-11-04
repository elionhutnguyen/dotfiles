# aspects/storage.nix
# Horizontal Aspect: Cross-class removable media mounting & virtual filesystems
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
