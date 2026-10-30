{ ... }:
{
  den.aspects.git = {
    nixos = {
      programs.git.enable = true;
    };

    homeManager = { config, ... }:
      let
        sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/programs/terminal/git";
      in
      {
        xdg.configFile."git".source =
          config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
      };
  };
}
