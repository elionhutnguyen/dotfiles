{ ... }:
{
  den.aspects.neovim = {
    nixos = { pkgs, ... }: {
      programs.neovim = {
        enable = true;
	defaultEditor = true;
      };
    };

    homeManager = { config, pkgs, ... }:
      let
        dotconfigs = "${config.home.homeDirectory}/dotfiles/dotconfigs";
      in
      {
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
          config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/nvim";
      };
  };
}
