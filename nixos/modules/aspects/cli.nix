{ ... }:
let
  dotconfigs = "/home/elio/dotfiles/dotconfigs";
in

{
  den.aspects.cli.nixos = { pkgs, ... }: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };

    programs.git = {
      enable = true;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withRuby = false;
      withPython3 = false;
    };
  };

  den.aspects.cli.homeManager = { config, pkgs, ... }: {
    programs.lf = {
      enable = true;
      extraConfig = "source ${dotconfigs}/lf/lfrc";
    };

    home.packages = with pkgs; [ ouch ];
    programs.zsh.autocd = true;
  };
}
