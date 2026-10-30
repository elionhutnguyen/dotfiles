{ ... }:
{
  den.aspects.neovim = {
    nixos = {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
      };
    };

    homeManager = { config, pkgs, ... }:
      let
        sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/programs/terminal/neovim";
      in
      {
        programs.neovim = {
          enable = true;
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
