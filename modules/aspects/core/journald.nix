{ ... }:
{
  den.aspects.journald.nixos = {
    services.journald.settings.Journal = {
      SystemMaxUse="500M";
      SystemMaxFiles=5;
    };
  };
}
