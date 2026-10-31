{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/desktop-environment.nix
    ../../modules/virtualization.nix  # Uncomment if you want Docker/KVM on this host
  ];

  # Host-specific settings
  networking.hostName = "xps";
  
  # Desktop environment for laptop
  desktop.enable = true;

  # Swap: compressed RAM swap first, 16 GiB disk swapfile as overflow.
  zramSwap = {
    enable = true;
    memoryPercent = 50;   # ~8 GiB max, compressed
    algorithm = "zstd";
    priority = 100;       # higher priority -> filled before disk swap
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;   # MiB; matches the existing file, so it is reused
      priority = 10;
    }
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;  # prefer reclaiming into swap/zram
    "vm.page-cluster" = 0;  # single-page reads, zram-friendly
  };
  
  # Laptop-specific settings can go here
  # Example: Power management for laptops
  # services.tlp.enable = true;
  # services.thermald.enable = true;
  
  # System state version
  system.stateVersion = "24.05";
}
