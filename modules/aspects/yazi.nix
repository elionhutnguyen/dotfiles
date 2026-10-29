{ ... }:
{
  den.aspects.yazi.homeManager = { config, pkgs, ... }:
    let
      dotconfigs = "${config.home.homeDirectory}/dotfiles/dotconfigs";
    in
    {
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
      };
      xdg.configFile."yazi".source =
        config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/yazi";
    };
}

