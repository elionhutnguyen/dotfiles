{ ... }:
{
  den.aspects.archives.homeManager = { pkgs, ... }: {
    home.packages = [
      pkgs._7zz-rar
    ];
  };
}
