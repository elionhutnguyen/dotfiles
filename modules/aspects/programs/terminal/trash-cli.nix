{ ... }:
{
  den.aspects.trash-cli.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.trash-cli ];
  };
}
