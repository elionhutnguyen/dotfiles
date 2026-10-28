{ ... }:
{
  den.aspects.zsh = {
    nixos = { pkgs, ... }: {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      };

      users.defaultUserShell = pkgs.zsh;
    };

    homeManager = { config, ... }:
      let
        dotconfigs = "${config.home.homeDirectory}/dotfiles/dotconfigs";
      in
      {
        home.file.".zshrc".source =
          config.lib.file.mkOutOfStoreSymlink "${dotconfigs}/zsh/.zshrc";
      };
  };
}
