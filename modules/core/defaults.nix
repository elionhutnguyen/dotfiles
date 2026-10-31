{ den, ... }:
{
  # Repository-wide global baseline settings
  den.default = {
    nixos.system.stateVersion = "26.05";
    homeManager.home.stateVersion = "26.05";
    nixos.home-manager.backupFileExtension = "backup";
    nixos.home-manager.useGlobalPkgs = true;
    nixos.home-manager.useUserPackages = true;
    includes = [
      den.batteries.define-user
      den.batteries.hostname
      den.batteries.primary-user
      den.batteries.host-aspects
    ];
  };
}
