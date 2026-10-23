{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/hardware.nix
    ./modules/desktop.nix
    ./modules/system.nix
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  users.users.elio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatic OS upgrades + weekly garbage collection (practical maintenance)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  system.autoUpgrade = {
    enable = true;
    flake = "/home/elio/dotfiles";
    dates = "weekly";
    operation = "switch";
  };

  # Keep the machine reachable for recovery
  services.openssh.enable = true;

  # Faster, more reliable suspend/resume with systemd-initrd (required for
  # nvidia's finegrained PM sleep hooks to work cleanly)
  boot.initrd.systemd.enable = true;

  # zsh lives in /etc/shells so it can be used as a login shell everywhere
  programs.zsh.enable = true;

  system.stateVersion = "26.05";
}
