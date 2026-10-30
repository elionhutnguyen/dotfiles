{ ... }:
{
  den.aspects._7zz-rar.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs._7zz-rar ];
  };
}
