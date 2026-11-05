# aspects/desktop.nix
# Horizontal Aspect: Multi-class Wayland desktop glue (Niri, Noctalia, PAM Keyring)
{ ... }:
{
  den.aspects.desktop = {
    nixos =
      { pkgs, ... }:
      {
        # Enable system-level Niri vertical module (includes self-contained portals & Greetd)
        my.niri-system.enable = true;

        # PAM Auto-Unlock & Wayland Ozone Environment
        security.pam.services.greetd.enableGnomeKeyring = true;
        environment.systemPackages = [ pkgs.wl-clipboard ];
        environment.sessionVariables = {
          NIXOS_OZONE_WL = "1";
        };
      };

    homeManager = {
      my.noctalia.enable = true;
      my.niri = {
        enable = true;
        shell = "noctalia";
        terminal = "ghostty";
        fileManager = "yazi";
      };
    };
  };
}
