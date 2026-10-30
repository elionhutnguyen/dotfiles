{ ... }:
{
  den.aspects.udiskie.homeManager = {
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };
  };
}
