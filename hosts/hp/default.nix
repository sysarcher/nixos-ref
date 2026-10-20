{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/desktop-environment.nix
    ../../modules/virtualization.nix
  ];

  # Host-specific settings
  networking.hostName = "hp";
  
  # Enable desktop-specific features for this host
  desktop.enable = true;

  # 32 GiB swapfile on the root filesystem (sdb2), no hibernation
  swapDevices = [
    {
      device = "/swapfile";
      size = 32 * 1024; # MiB
    }
  ];

  services.teamviewer.enable = true;
  
  # System state version
  system.stateVersion = "24.05";
}
