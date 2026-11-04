{ ... }:
{
  den.aspects.vscode.homeManager = { config, pkgs, ... }: 
    {
      programs.vscode = {
        enable = true;
        package = pkgs.vscode.override {
          commandLineArgs = [
            "--enable-features=UseOzonePlatform"
            "--ozone-platform=wayland"
          ];
        };
        
        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            supermaven.supermaven
            saoudrizwan.claude-dev  # Cline Agent
          ];
        };
      };
    };
}
