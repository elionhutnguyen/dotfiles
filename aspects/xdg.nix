# aspects/xdg.nix
# Horizontal Aspect: Cross-class XDG directory hygiene without breaking Wine, GTK, wget, or Trash
{ ... }:
{
  den.aspects.xdg = {
    # Outward Push: Configure local XDG option of the vertical `nix-daemon` module
    nixos = {
      my.nix-daemon.useXdgDirectories = true;
    };

    homeManager =
      { config, ... }:
      let
        unusedXdgDir = "${config.xdg.dataHome}/xdg-unused";
      in
      {
        home.preferXdgDirectories = true;

        xdg = {
          enable = true;
          userDirs = {
            enable = true;
            createDirectories = false;
            setSessionVariables = false;

            # Keep only Documents, Downloads, and Pictures in ~
            documents = "${config.home.homeDirectory}/Documents";
            download = "${config.home.homeDirectory}/Downloads";
            pictures = "${config.home.homeDirectory}/Pictures";

            # Isolate unused XDG dirs in ~/.local/share/xdg-unused so:
            # 1. Browsers/Wine never recreate ~/Desktop, ~/Music, ~/Videos in ~
            # 2. Wine/Faugus and GTK never treat $HOME itself as Desktop or Templates
            desktop = unusedXdgDir;
            music = unusedXdgDir;
            videos = unusedXdgDir;
            templates = unusedXdgDir;
            publicShare = unusedXdgDir;
          };
        };

        home.sessionVariables = {
          NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
          NODE_REPL_HISTORY = "${config.xdg.stateHome}/node_repl_history";
          CARGO_HOME = "${config.xdg.dataHome}/cargo";
          RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
          GOPATH = "${config.xdg.dataHome}/go";
          GNUPGHOME = "${config.xdg.dataHome}/gnupg";
          CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
          __GL_SHADER_DISK_CACHE_PATH = "${config.xdg.cacheHome}/nv";
          DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
          DOCKER_CONFIG = "${config.xdg.configHome}/docker";
        };

        systemd.user.tmpfiles.rules = [
          # Ensure required XDG subdirectories exist
          "d %h/.local/share/xdg-unused 0700 - - - -"
          "d %h/.config/npm 0755 - - - -"
          "d %h/.local/share/gnupg 0700 - - - -"
          "d %h/.cache/nv 0755 - - - -"

          # Safe 30-day age pruning on regenerable ~/.cache only
          "e %h/.cache - - - 30d"
        ];
      };
  };
}
