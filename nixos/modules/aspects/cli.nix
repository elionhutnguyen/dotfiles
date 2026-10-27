{ ... }:
let
  dotconfigs = "/home/elio/dotfiles/dotconfigs";
in
{
  den.aspects.cli.homeManager = { config, pkgs, ... }: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        if [ -f "${dotconfigs}/zsh/.zshrc" ]; then
          source "${dotconfigs}/zsh/.zshrc"
        fi
      '';
    };

    programs.git = {
      enable = true;
      includes = [ { path = "${dotconfigs}/git/config"; } ];
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withRuby = false;
      withPython3 = false;
      extraLuaConfig = ''
        local init_file = "${dotconfigs}/nvim/init.lua"
        if vim.uv.fs_stat(init_file) then
          dofile(init_file)
        end
      '';
    };

    programs.lf = {
      enable = true;
      extraConfig = "source ${dotconfigs}/lf/lfrc";
    };

    home.packages = with pkgs; [ ouch ];
  };
}
