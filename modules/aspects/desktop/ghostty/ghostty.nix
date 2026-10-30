{ config, ... }:
let
  sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/desktop/ghostty";
in
{
  den.aspects.ghostty.homeManager = {
    programs.ghostty.enable = true;

    xdg.configFile."ghostty".source =
      config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
  };
}
