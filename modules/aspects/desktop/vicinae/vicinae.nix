{ ... }:
{
  den.aspects.vicinae.homeManager = { config, ... }:
    let
      sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/desktop/vicinae";
    in
    {
      programs.vicinae = {
        enable = true;
        systemd.enable = true;
      };

      xdg.configFile."vicinae".source =
        config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
    };
}
