# users/elio.nix
# User Entity: Personal identity & composed workspace aspects
{ den, ... }:
let
  user = {
    name = "elionhutnguyen";
    email = "elio.nhutnguyen@gmail.com";
  };
in
{
  den.aspects.elio = {
    homeManager.programs = {
      git.settings = { inherit user; };
      jujutsu.settings = { inherit user; };
    };

    includes = with den.aspects; [
      zsh
      neovim
      vcs
      cli-tools
      python
      antigravity
      firefox
      gui-apps
      gaming
    ];
  };
}
