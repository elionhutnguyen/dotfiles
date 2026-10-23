{ inputs, pkgs, ... }:

{
  imports = [
    inputs.umbriel.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  # 1. Automatic GPU switching daemon for desktop applications
  services.switcheroo-control.enable = true;

  # 2. Umbriel Compositor & Cachix Pre-built Cache
  programs.umbriel.enable = true;
  nix.settings = {
    extra-substituters = [ "https://umbriel.cachix.org" ];
    extra-trusted-public-keys = [ "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw=" ];
  };

  # 3. Noctalia Greeter (Default settings)
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      keyboard.layout = "us";
    };
  };
  services.accountsService.enable = true;

  # 4. Audio & Bluetooth
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # 5. Noctalia Daemons
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
