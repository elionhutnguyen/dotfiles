{ ... }:
let
  dotconfigs = "home/elio/dotfiles/dotconfigs";
in
{
  den.aspects.noctalia = {
    nixos = { pkgs, ... }: {
      programs.noctalia = {
        enable = true;
	systemd.enable = true;
	recommendedServices.enable = true;
      };
    };

    homeManager = { config, ... }: {
      xdg.configFile."noctalia/config.toml".source = 
        config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/noctalia/config.toml";
    };
  };
}
