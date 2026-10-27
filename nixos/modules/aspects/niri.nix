{ ... }:
let
  dotconfigs = "/home/elio/dotfiles/dotconfigs";
in
{
  den.aspects.niri = {
    nixos = { pkgs, ... }: {
      programs.niri.enable = true;
    };

    homeManager = { config, ... }: {
      wayland.windowManager.niri = {
        enable = true;
	systemd.enable = true;
	#enableDefaultConfig = true;
	#extraConfig = "spawn-at-startup "noctalia"";
      };
      xdg.configFile."niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/niri/config.kdl";
    };
  };
}
