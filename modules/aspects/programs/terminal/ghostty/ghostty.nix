{ ... }:
{
  den.aspects.ghostty.homeManager = { config, ... }:
    let
      sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/programs/terminal/ghostty";
    in
    {
      programs.ghostty.enable = true;

      xdg.configFile."ghostty".source =
        config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
    };
}
