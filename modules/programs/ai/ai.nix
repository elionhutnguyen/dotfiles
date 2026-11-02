{ ... }:
{
  den.aspects.ai = {
    homeManager = { config, pkgs, ... }:
      let
        baseDir = "${config.home.homeDirectory}/dotfiles/modules/programs/ai";
      in
      {
        # Install CLI Agent Binaries
        home.packages = with pkgs; [
          goose-cli      # Linux Foundation MCP autonomous agent
          opencode       # High-speed terminal coding agent
        ];

        # Symlink the DIRECTORIES containing config files out-of-store
        xdg.configFile."opencode".source =
          config.lib.file.mkOutOfStoreSymlink "${baseDir}/opencode/config";

        xdg.configFile."goose".source =
          config.lib.file.mkOutOfStoreSymlink "${baseDir}/goose/config";

        # Ensure runtime state folders exist in XDG directories
        systemd.user.tmpfiles.rules = [
          "d %h/.local/state/opencode 0700 - - - -"
          "d %h/.local/state/goose 0700 - - - -"
          "d %h/.cache/opencode 0700 - - - -"
        ];
      };
  };
}
