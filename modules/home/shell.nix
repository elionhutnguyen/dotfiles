{ ... }:

{
  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      # Rebuild từ bất kỳ thư mục nào
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
      nv = "auto-gpu";
      shot = "grim -g \"$(slurp)\" - | wl-copy";
      flameshot-gui = "env XDG_CURRENT_DESKTOP=sway flameshot gui";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };

  programs.bat.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = false;
      update_ms = 1500;
    };
  };
}
