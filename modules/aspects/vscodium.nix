{ ... }:
{
  den.aspects.vscodium.homeManager = { config, pkgs, ... }:
    let
      dotconfigs = "${config.home.homeDirectory}/dotfiles/dotconfigs";
    in
    {
      programs.vscodium.enable = true;

      xdg.configFile."VSCodium".source =
        config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/vscodium";
    };
}
