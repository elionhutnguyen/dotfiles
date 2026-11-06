# hosts/elio.nix
# User Composition: Thin declaration supplying user identity & enabling personal vertical modules
{ den, ... }:
{
  den.aspects.elio = {
    homeManager.my = {
      # Supply user identity directly to the vertical `vcs` module's local options
      vcs = {
        userName = "elionhutnguyen";
        userEmail = "elio.nhutnguyen@gmail.com";
      };

      # Primary AI Coding Assistant (Google Antigravity CLI)
      antigravity.enable = true;

      # Personal GUI Vertical Modules
      vscode.enable = true;
      gui-apps.enable = true;
      firefox.enable = true;
    };

    # Include genuine multi-class user aspects
    includes = with den.aspects; [
      cli-workspace
      gaming
    ];
  };
}
