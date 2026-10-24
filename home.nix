{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # List of configs to link: ~/.config/<item> -> ~/dotfiles/config/<item>
  configs = [
    "umbriel"
    "noctalia"
    "ghostty"
  ];
in
{
  home.username = "elio";
  home.homeDirectory = "/home/elio";
  home.stateVersion = "26.05";

  programs.bash.enable = true;

  # Personal Git Configuration
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = "elionhutnguyen";
      user.email = "elio.nhutnguyen@gmail.com";
    };
  };

  # User Applications & Wayland Utilities
  home.packages = with pkgs; [
    brave-origin
    anki-bin
    wl-clipboard # Wayland clipboard provider
    grim         # Wayland screenshot tool
    slurp        # Wayland screen area selector
  ];

  # Declarative XDG Standard
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    # Dynamic generation using builtins.listToAttrs
    configFile = builtins.listToAttrs (map (name: {
      inherit name;
      value = {
        source = create_symlink "${dotfiles}/${name}";
      };
    }) configs);
  };
}
