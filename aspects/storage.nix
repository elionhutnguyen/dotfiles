# aspects/storage.nix
# Horizontal Aspect: Cross-class removable media mounting & virtual filesystems
_: {
  den.aspects.storage = {
    nixos =
      { config, lib, ... }:
      {
        services.udisks2.enable = true;
        services.gvfs.enable = true;

        systemd.tmpfiles.rules = lib.mkIf (config.fileSystems ? "/home/data") [
          "d /home/data 0775 elio users -"
        ];
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
