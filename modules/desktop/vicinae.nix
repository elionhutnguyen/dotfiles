{ ... }:
{
  den.aspects.vicinae.homeManager = {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };
}
