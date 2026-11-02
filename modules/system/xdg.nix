{ ... }:
{
  den.aspects.xdg = {
    nixos = {
      environment.sessionVariables = {
        # Core XDG Base Specifications
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_CACHE_HOME  = "$HOME/.cache";
        XDG_DATA_HOME   = "$HOME/.local/share";
        XDG_STATE_HOME  = "$HOME/.local/state";

        # Clean $HOME from language runtimes & dev tools
        ZDOTDIR             = "$HOME/.config/zsh";
        NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc";
        NODE_REPL_HISTORY   = "$HOME/.local/state/node_repl_history";
        CARGO_HOME          = "$HOME/.local/share/cargo";
        RUSTUP_HOME         = "$HOME/.local/share/rustup";
        GOPATH              = "$HOME/.local/share/go";
        GNUPGHOME           = "$HOME/.local/share/gnupg";
        CUDA_CACHE_PATH     = "$HOME/.cache/nv";
        DOCKER_CONFIG       = "$HOME/.config/docker";
        WGETRC              = "$HOME/.config/wget/wgetrc";
        HISTFILE            = "$HOME/.local/state/zsh/history";
      };
    };

    homeManager = { config, ... }: {
      xdg = {
        enable = true;
        configHome = "${config.home.homeDirectory}/.config";
        cacheHome  = "${config.home.homeDirectory}/.cache";
        dataHome   = "${config.home.homeDirectory}/.local/share";
        stateHome  = "${config.home.homeDirectory}/.local/state";
      };

      # Clean empty cache & trash files automatically
      systemd.user.tmpfiles.rules = [
        "d %h/.local/state/zsh 0700 - - - -"
        "d %h/.cache/zsh 0700 - - - -"
        "d %h/.config/npm 0755 - - - -"
      ];
    };
  };
}
