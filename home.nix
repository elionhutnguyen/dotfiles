{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard XDG mapping: ~/.config/<key> -> ~/dotfiles/config/<val>
  configs = {
    umbriel  = "umbriel";
    noctalia = "noctalia";
  };
in
{
  home.username = "elio";
  home.homeDirectory = "/home/elio";
  home.stateVersion = "26.05";

  programs.bash.enable = true;
  programs.git.enable = true;

  # User Applications
  home.packages = with pkgs; [
    brave
    anki
    wl-clipboard
    grim
    slurp
  ];

  # Declarative XDG Standard
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    # Dynamic loop generating out-of-store symlinks
    configFile = builtins.mapAttrs (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    }) configs;
  };
}
