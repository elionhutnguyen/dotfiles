{ ... }:
{
  den.aspects.vscode.homeManager = { config, pkgs, ... }: 
    let
      sliceDir = "${config.home.homeDirectory}/dotfiles/modules/programs/gui/vscode";
    in
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

      # Out-of-store directory symlink for VS Code configuration
      xdg.configFile."Code/User".source =
        config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
    };
}
