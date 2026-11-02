{ ... }:
{
  den.aspects.zsh = {
    nixos = { pkgs, ... }: {
      programs.zsh = {
        enable = true;
        enableCompletion = false; # Handled via modular config
      };
      users.defaultUserShell = pkgs.zsh;
      environment.pathsToLink = [ "/share/zsh" ];
    };

    homeManager = { config, pkgs, ... }:
      let
        sliceDir = "${config.home.homeDirectory}/dotfiles/modules/programs/cli/zsh";
      in
      {
        # Ensure underlying binary dependencies exist on PATH
        home.packages = with pkgs; [
          bat
          eza
          fd
          fzf
          ripgrep
          starship
          zoxide
          git
        ];

        # Symlink the entire zsh configuration directory out of store
        xdg.configFile."zsh".source =
          config.lib.file.mkOutOfStoreSymlink "${sliceDir}/config";

        # Link .zshenv to ~/.zshenv so Zsh sets ZDOTDIR to ~/.config/zsh on launch
        home.file.".zshenv".text = ''
          export ZDOTDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
          [[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
        '';
      };
  };
}
