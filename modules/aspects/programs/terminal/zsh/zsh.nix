{ config, ... }:
let
  sliceDir = "${config.home.homeDirectory}/dotfiles/modules/aspects/programs/terminal/zsh";
in
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

    homeManager = { config, ... }: {
      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
        initContent = ''
          if [ -f "${sliceDir}/config/.zshrc" ]; then
            source "${sliceDir}/config/.zshrc"
          fi
        '';
      };
    };
  };
}
