{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/core.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/desktop.nix
  ];
}
