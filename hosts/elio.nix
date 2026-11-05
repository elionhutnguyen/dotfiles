# hosts/elio.nix
# User Composition: Thin declaration supplying user identity & enabling personal vertical modules
{ den, ... }:
{
  den.aspects.elio = {
    homeManager = {
      # Supply user identity directly to the vertical `vcs` module's local options
      my.vcs = {
        userName = "elionhutnguyen";
        userEmail = "elio.nhutnguyen@gmail.com";
      };

      # Primary AI Coding Assistant (Google Antigravity CLI)
      my.antigravity.enable = true;

      # Personal GUI, Terminal & Diagnostic Vertical Modules
      my.ghostty.enable = true;
      my.vscode.enable = true;
      my.gui-apps.enable = true;
      my.firefox.enable = true;
      my.mpv.enable = true;
      my.hw-diag.enable = true;
    };

    # Include genuine multi-class user aspects
    includes = with den.aspects; [
      cli-workspace
      gaming
    ];
  };
}
