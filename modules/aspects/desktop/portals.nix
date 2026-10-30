{ ... }:
{
  den.aspects.portals.nixos = {
    xdg.portal = {
      enable = true;
      config.common.default = [ "gtk" ];
    };

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
    programs.dconf.enable = true;
    environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  };
}
