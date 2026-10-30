{ config, ... }:
let
  sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/programs/terminal/neovim";
in
{
  den.aspects.neovim = {
    nixos = {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
      };
    };

    homeManager = { pkgs, ... }: {
      programs.neovim = {
        sideloadInitLua = true;
        extraPackages = with pkgs; [
          ripgrep
          fd
          lua-language-server
          nixd
        ];
      };

      xdg.configFile."nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";
    };
  };
}
