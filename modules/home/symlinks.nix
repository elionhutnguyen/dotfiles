{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = [
    "umbriel"
    "noctalia"
    "ghostty"
    "mpv"
    "nvim"
    "yazi"
    "sioyek"
  ];
in
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    configFile = builtins.listToAttrs (map (name: {
      inherit name;
      value = {
        source = create_symlink "${dotfiles}/${name}";
      };
    }) configs);
  };
}
