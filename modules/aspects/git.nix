{ ... }:
{
  den.aspects.git = {
    nixos = {
      programs.git.enable = true;
    };

    homeManager = { config, ... }:
      let
        dotconfigs = "${config.home.homeDirectory}/dotfiles/dotconfigs";
      in
      {
        xdg.configFile."git".source =
          config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/git";
      };
  };
}
