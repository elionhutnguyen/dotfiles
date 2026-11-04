{ ... }:
{
  den.aspects.goose = {
    homeManager = { config, pkgs, ... }:
      let
        baseDir = "${config.home.homeDirectory}/dotfiles/modules/programs/ai";
      in
      {
        # Install CLI Agent Binaries
        home.packages = with pkgs; [
          goose-cli      # Linux Foundation MCP autonomous agent
        ];

        # Symlink Goose configuration out-of-store
        xdg.configFile."goose".source =
          config.lib.file.mkOutOfStoreSymlink "${baseDir}/goose/config";

        # Ensure runtime state folders exist in XDG directories
        systemd.user.tmpfiles.rules = [
          "d %h/.local/state/goose 0700 - - - -"
        ];
      };
  };
}
