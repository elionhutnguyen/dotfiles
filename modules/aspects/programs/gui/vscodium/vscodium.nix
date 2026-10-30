{ ... }:
{
  den.aspects.vscodium.homeManager = { config, ... }:
    let
      sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/programs/gui/vscodium";
    in
    {
      programs.vscodium.enable = true;

      xdg.configFile."VSCodium".source =
        config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
    };
}
