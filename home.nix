{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard XDG mapping: ~/.config/<key> -> ~/dotfiles/config/<val>
  configs = {
    umbriel  = "umbriel";
    noctalia = "noctalia";
  };

  # Declarative dotfiles symlinked into ~/.config (merged with ghostty below)
  dotfileLinks = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
in
{
  home.username = "elio";
  home.homeDirectory = "/home/elio";
  home.stateVersion = "26.05";

  programs.git.enable = true;

  # Shell & Terminal (zsh is the only interactive shell)
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "robbyrussell";
    };
  };

  # User Applications
  home.packages = with pkgs; [
    ghostty
    brave
    anki
    wl-clipboard
  ];

  # Declarative XDG Standard
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    # Ghostty's config file is managed declaratively (its .desktop entry ships
    # with the package itself, so no xdg.desktopEntries override is needed).
    configFile = dotfileLinks // {
      "ghostty/config".text = ''
        shell-integration = zsh
        theme = catppuccin-mocha
      '';
    };
  };
}
