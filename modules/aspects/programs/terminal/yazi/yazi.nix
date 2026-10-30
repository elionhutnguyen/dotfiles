{ config, ... }:
let
  sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/programs/terminal/yazi";
in
{
  den.aspects.yazi.homeManager = {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    xdg.configFile."yazi".source =
      config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
  };
}
