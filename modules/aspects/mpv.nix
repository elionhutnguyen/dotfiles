{ ... }:
{
  den.aspects.mpv.homeManager = { config, ... }:
    let
      dotconfigs = "${config.home.homeDirectory}/dotfiles/dotconfigs";
    in
    {
      programs.mpv.enable = true;

      xdg.configFile."mpv".source =
        config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/mpv";
    };
}
