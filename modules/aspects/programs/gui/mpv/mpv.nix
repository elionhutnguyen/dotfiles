{ ... }:
{
  den.aspects.mpv.homeManager = { config, ... }:
    let
      sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/programs/gui/mpv";
    in
    {
      programs.mpv.enable = true;

      xdg.configFile."mpv".source =
        config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
    };
}
