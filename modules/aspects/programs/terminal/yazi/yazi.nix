{ ... }:
{
  den.aspects.yazi.homeManager = { config, ... }:
    let
      sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/programs/terminal/yazi";
    in
    {
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
	shellWrapperName = "y";
      };

      xdg.configFile."yazi".source =
        config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
    };
}
