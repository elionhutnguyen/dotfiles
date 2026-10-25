{ ... }:

{
  home.username = "elio";
  home.homeDirectory = "/home/elio";
  home.stateVersion = "26.05";

  imports = [
    ./symlinks.nix
    ./shell.nix
    ./programs.nix
  ];
}
