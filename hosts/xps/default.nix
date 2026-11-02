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

  # Offload builds to hp over Tailscale. Reuses taimoor's existing SSH key,
  # which is already authorized on hp. hp has taimoor in trusted-users, so
  # writes to its store are permitted.
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;
  nix.settings.connect-timeout = 10; # fail fast if hp is unreachable

  nix.buildMachines = [{
    hostName = "100.111.207.115";
    sshUser = "taimoor";
    sshKey = "/home/taimoor/.ssh/id_ed25519";
    protocol = "ssh-ng";
    system = "x86_64-linux";
    maxJobs = 8;         # hp has 8 cores
    speedFactor = 2;     # prefer hp over local
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  }];

  # Let root's ssh (the nix daemon) verify hp's host key. This is written to
  # /etc/ssh/ssh_known_hosts, which root's ssh reads in addition to
  # /root/.ssh/known_hosts.
  programs.ssh.knownHosts.hp = {
    hostNames = [ "100.111.207.115" "hp" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSIICqkTZWEiZwfFLRVp/JsQoBDJq3mpUVeZXKV57Is";
  };

  # System state version
  system.stateVersion = "24.05";
}
