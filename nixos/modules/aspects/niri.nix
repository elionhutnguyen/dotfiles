{ pkgs, ... }:
let
  dotfilesRoot = "/home/elio/.dotfiles/dotfiles-src";
in
{
  den.aspects.niri = {
    nixos = { ... }: {
      programs.niri.enable = true;
      environment.systemPackages = [ pkgs.noctalia ];
    };

    homeManager = { config, ... }: {
      # Rule 3: Live symlink out-of-store
      xdg.configFile."niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/niri/config.kdl";
        
      xdg.configFile."noctalia/config.json".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/noctalia/config.json";
    };
  };
}
