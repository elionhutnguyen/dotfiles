# aspects/gui-apps.nix
# Aspect: Desktop productivity, browser, messaging, office & VSCode applications
_: {
  den.aspects.gui-apps.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.anki-bin
        (pkgs.brave-origin.override {
          commandLineArgs = "--disable-accelerated-video-encode";
        })
        pkgs.linux-wifi-hotspot
        pkgs.materialgram
      ];

      programs = {
        onlyoffice.enable = true;
        vscode.enable = true;
      };
    };
}
