{ ... }:
{
  den.aspects.comma.nixos = { inputs, ... }: {
    imports = [ inputs.nix-index-database.nixosModules.default ];
    programs.nix-index-database.comma.enable = true;
  };
}
