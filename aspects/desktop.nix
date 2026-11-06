# aspects/desktop.nix
# Horizontal Aspect: Multi-class Wayland desktop glue (Niri, Noctalia, Ghostty)
_: {
  den.aspects.desktop = {
    nixos =
      { pkgs, ... }:
      {
        # Enable system-level Niri vertical module (includes self-contained portals, keyring & Greetd)
        my.niri-system.enable = true;

        # Wayland Clipboard & Ozone Environment
        environment = {
          systemPackages = [ pkgs.wl-clipboard ];
          sessionVariables = {
            NIXOS_OZONE_WL = "1";
          };
        };
      };

    homeManager.my = {
      noctalia.enable = true;
      ghostty.enable = true;
      niri = {
        enable = true;
        shell = "noctalia";
        terminal = "ghostty";
        fileManager = "yazi";
      };
    };
  };
}
