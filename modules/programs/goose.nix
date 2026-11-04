{ ... }:
{
  den.aspects.goose = {
    homeManager = { config, pkgs, ... }:
      {
        # Install CLI Agent Binaries
        home.packages = with pkgs; [
          goose-cli      # Linux Foundation MCP autonomous agent
        ];

        # Ensure runtime state folders exist in XDG directories
        systemd.user.tmpfiles.rules = [
          "d %h/.local/state/goose 0700 - - - -"
        ];
      };
  };
}
