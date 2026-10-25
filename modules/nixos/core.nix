{ pkgs, ... }:

{
  # --- Boot & Kernel ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "asus-nb-wmi" ];

  # --- Networking ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # --- Locale & Time ---
  time.timeZone = "Asia/Taipei";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.supportedLocales = [
    "en_GB.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "zh_TW.UTF-8/UTF-8"
  ];
  services.xserver.xkb.layout = "us";
  console.keyMap = "us";

  # --- User Accounts & System Shell ---
  programs.zsh.enable = true;
  users.users.elio = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };
  systemd.tmpfiles.rules = [ "d /home/elio/data 0755 elio users -" ];

  # --- System Base Packages & Environment ---
  programs.git.enable = true;
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  environment.systemPackages = with pkgs; [ pciutils ];

  # --- Nix Settings ---
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ "https://umbriel.cachix.org" ];
    extra-trusted-public-keys = [
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
    ];
  };

  system.stateVersion = "26.05";
}
