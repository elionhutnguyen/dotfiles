{ pkgs, ... }:

{
  # --- Git Configuration ---
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = "elionhutnguyen";
      user.email = "elio.nhutnguyen@gmail.com";
    };
  };

  # --- Neovim Toolchain ---
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    sideloadInitLua = true;
    extraPackages = with pkgs; [
      tree-sitter
      gcc
      ripgrep
      fd
    ];
  };

  # --- Web & File Manager ---
  programs.firefox.enable = true;
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  # --- User Applications ---
  home.packages = with pkgs; [
    # GUI & Productivity
    ghostty
    brave-origin
    anki-bin
    onlyoffice-desktopeditors
    sioyek

    # Media
    mpv
    yt-dlp

    # Wayland Utilities
    wl-clipboard
    flameshot
    grim
    slurp
    libnotify

    # Monitoring & CLI
    nvtopPackages.full
    ripgrep
    fd
    faugus-launcher
  ];
}
