{ ... }:
{
  den.aspects.ghostty.homeManager = { config, ... }:
    let
      dotconfigs = "${config.home.homeDirectory}/dotfiles/dotconfigs";
    in
    {
      programs.ghostty.enable = true;

      xdg.configFile."ghostty".source =
        config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/ghostty";
    };
}
