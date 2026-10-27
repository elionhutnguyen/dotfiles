{ pkgs, ... }:
let
  dotfilesRoot = "/home/elio/.dotfiles/dotfiles-src";
in
{
  den.aspects.cli.homeManager = { config, ... }: {
    # Rule 1 & 2 Compliant
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        if [ -f "${dotfilesRoot}/zsh/.zshrc" ]; then
          source "${dotfilesRoot}/zsh/.zshrc"
        fi
      '';
    };

    programs.git = {
      enable = true;
      includes = [ { path = "${dotfilesRoot}/git/config"; } ];
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraLuaConfig = ''
        local init_file = "${dotfilesRoot}/nvim/init.lua"
        if vim.uv.fs_stat(init_file) then
          dofile(init_file)
        end
      '';
    };

    programs.lf = {
      enable = true;
      extraConfig = "source ${dotfilesRoot}/lf/lfrc";
    };

    home.packages = with pkgs; [ p7zip atool ];
  };
}
