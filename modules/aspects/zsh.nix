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
        programs.zsh = {
          enable = true
          dotDir = "${config.xdg.configHome}/zsh";
          initContent = ''
            if [ -f "${dotconfigs}/zsh/.zshrc" ]; then
              source "${dotconfigs}/zsh/.zshrc"
            fi
          '';
        };
      };
  };
}
