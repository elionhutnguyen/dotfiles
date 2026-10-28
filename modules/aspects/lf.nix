{ ... }:
{
  den.aspects.lf = {
    homeManager = { config, ... }:
      let
        dotconfigs = "${config.home.homeDirectory}/dotfiles/dotconfigs";
      in
      {
        programs.lf = {
          enable = true;
        };

        xdg.configFile."lf/lfrc".enable = false;

        xdg.configFile."lf".source =
          config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/lf";
      };
  };
}
