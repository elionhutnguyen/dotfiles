{ config, ... }:
let
  sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/desktop/vicinae";
in
{
  den.aspects.vicinae.homeManager = {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
    };

    xdg.configFile."vicinae".source =
      config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
  };
}
