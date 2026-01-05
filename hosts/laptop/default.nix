{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/desktop-environment.nix
    # ../../modules/virtualization.nix  # Uncomment if you want Docker/KVM on this host
  ];

  # Host-specific settings
  networking.hostName = "laptop";
  
  # Desktop environment for laptop
  desktop.enable = true;
  
  # Laptop-specific settings can go here
  # Example: Power management for laptops
  # services.tlp.enable = true;
  # services.thermald.enable = true;
  
  # System state version
  system.stateVersion = "24.05";
}
