# modules/system/xdg.nix
{ ... }:
{
  den.aspects.xdg = {
    homeManager =
      { config, ... }:
      {
        home.preferXdgDirectories = true;

        xdg = {
          enable = true;
          configHome = "${config.home.homeDirectory}/.config";
          cacheHome = "${config.home.homeDirectory}/.cache";
          dataHome = "${config.home.homeDirectory}/.local/share";
          stateHome = "${config.home.homeDirectory}/.local/state";

          userDirs = {
            enable = true;
            createDirectories = false;
            setSessionVariables = false;
          };
        };

        # Resolved absolute XDG paths (avoids literal "$HOME" bugs in PAM sessionVariables)
        home.sessionVariables = {
          NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
          NODE_REPL_HISTORY = "${config.xdg.stateHome}/node_repl_history";
          CARGO_HOME = "${config.xdg.dataHome}/cargo";
          RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
          GOPATH = "${config.xdg.dataHome}/go";
          GNUPGHOME = "${config.xdg.dataHome}/gnupg";
          CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
          DOCKER_CONFIG = "${config.xdg.configHome}/docker";
          WGETRC = "${config.xdg.configHome}/wget/wgetrc";
        };

        systemd.user.tmpfiles.rules = [
          "d %h/.config/npm 0755 - - - -"
          "d %h/.local/share/gnupg 0700 - - - -"
        ];
      };
  };
}
