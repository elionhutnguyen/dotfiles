# aspects/defaults.nix
# Horizontal Baseline: Repository-wide stateVersion, HM integration, and Den batteries
{ den, ... }:
{
  den.default = {
    nixos = {
      system.stateVersion = "26.05";
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
      };
      environment.pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];
    };
    homeManager.home.stateVersion = "26.05";
    includes = [
      den.batteries.define-user
      den.batteries.hostname
      den.batteries.primary-user
      den.batteries.host-aspects
    ];
  };
}
