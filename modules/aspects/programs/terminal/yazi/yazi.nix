{ ... }:
{
  den.aspects.yazi.homeManager = { config, pkgs, ... }:
    let
      sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/programs/terminal/yazi";
    in
    {
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
        shellWrapperName = "y";
        package = pkgs.yazi.override {
          _7zz = pkgs._7zz-rar;
        };
      };

      xdg.configFile."yazi".source =
        config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
    };
}
