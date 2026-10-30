{ ... }:
{
  den.aspects.oomd.nixos = {
    systemd.oomd = {
      enable = true;
      enableUserSlices = true;
    };
  };
}
