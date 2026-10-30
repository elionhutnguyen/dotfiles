{ config, ... }:
let
  sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/programs/gui/mpv";
in
{
  den.aspects.mpv.homeManager = {
    programs.mpv.enable = true;

    xdg.configFile."mpv".source =
      config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
  };
}
