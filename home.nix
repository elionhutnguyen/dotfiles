{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # List of configs linked directly: ~/.config/<item> -> ~/dotfiles/config/<item>
  # Allows live edits without running 'home-manager switch'
  configs = [
    "umbriel"   # Compositor configs
    "noctalia"  # Desktop shell & bar
    "ghostty"   # Terminal themes & keybinds
    "mpv"       # mpv.conf, input.conf, scripts
    "nvim"      # Neovim Lua configurations
    "yazi"      # File manager plugins & keymaps
    "sioyek"    # PDF reader keys_user.config & prefs_user.config
  ];
in
{
  home.username = "elio";
  home.homeDirectory = "/home/elio";
  home.stateVersion = "26.05";

  # --- Shell Configurations ---
  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      nv = "auto-gpu"; # GPU offload alias
      
      # Wayland Screenshot Aliases:
      shot = "grim -g \"$(slurp)\" - | wl-copy";
      flameshot-gui = "env XDG_CURRENT_DESKTOP=sway flameshot gui";
    };
  };

  # --- Text Editor (Neovim with Isolated Build Toolchain) ---
  programs.neovim = {
    enable = true;
    defaultEditor = true; # Exports EDITOR=nvim & VISUAL=nvim
    viAlias = true;
    vimAlias = true;

    # CRITICAL: Prevents Home Manager from writing a generated init.lua into
    # ~/.config/nvim, avoiding collisions with your out-of-store symlink.
    sideloadInitLua = true;

    # Injects build tools & utilities directly into Neovim's internal PATH wrapper
    extraPackages = with pkgs; [
      tree-sitter # Treesitter CLI for compiling grammar parsers
      gcc         # C compiler required for tree-sitter build
      ripgrep     # High-speed backend for Telescope live_grep
      fd          # High-speed backend for Telescope find_files
    ];
  };

  # --- Productivity & Shell Enhancers (Modules) ---
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

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  # --- Git Configuration ---
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = "elionhutnguyen";
      user.email = "elio.nhutnguyen@gmail.com";
    };
  };

  # --- User Applications & Standalone Packages ---
  home.packages = with pkgs; [
    # GUI & Productivity Applications
    ghostty
    brave-origin
    anki-bin
    onlyoffice-desktopeditors
    sioyek

    # Media & Playback
    mpv
    yt-dlp # Essential companion for mpv to play online URLs

    # Wayland Utilities & Screen Capture
    wl-clipboard
    flameshot
    grim
    slurp
    libnotify

    # Hardware Monitoring
    nvtopPackages.full # Real-time AMD iGPU + Nvidia GTX 1650 monitor

    # High-Performance CLI Tools (Available in your shell)
    ripgrep
    fd
  ];

  # --- Declarative XDG Standard & Out-of-Store Symlinks ---
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    # Dynamic mapping: ~/.config/<item> -> ~/dotfiles/config/<item>
    configFile = builtins.listToAttrs (map (name: {
      inherit name;
      value = {
        source = create_symlink "${dotfiles}/${name}";
      };
    }) configs);
  };
}
