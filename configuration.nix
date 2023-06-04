# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Timeserver
  networking.timeServers = options.networking.timeServers.default ++ [ "corp.intel.com" "time.cloudflare.com" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "jmp-openshift"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  networking.proxy.default = "http://proxy-chain.intel.com:912/";
  networking.proxy.noProxy = "127.0.0.1,localhost,intel.com,api.graph.intel.com,oauth-openshift.apps.graph.intel.com,console-openshift-console.apps.graph.intel.com,grafana-openshift-monitoring.apps.graph.intel.com,thanos-querier-openshift-monitoring.apps.graph.intel.com,default-route-openshift-image-registry.apps.graph.intel.com,.intel.com";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = [ "192.168.1.1" ];
  networking.interfaces.eno2.ipv4.addresses = [ {
    address = "192.168.1.1";
    prefixLength = 24;
  } ];

  # kernel options
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  environment.shells = with pkgs; [ zsh ];
  users.users.intel = {
    isNormalUser = true;
    description = "intel";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };
  users.users.intel.openssh.authorizedKeys.keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdgcWg5YZHHpCDjAczh7xs2kxPNk6yi6hOcRvzq6d9+Uv1cT6QKYav6ZSTmWx1EVusOtLSr4QA1tjMbX1vi/eeidlPpCacznU8oPm/Z7b9arVf4IiI6BWqJF4xfIr+0DnXOxpbbHbGbfMHu/M924PdWVKD8qrVv54ZrkAsYHCHoci9hFNUtHy9U38PSiq20VKz1bo2ngU+iLRM2ZLJ49PHlFI4YvPkg1m2rhKAdxXRtxgsD6gx4+pMKQDzJxQjh7AkyO6PoAgif1pqnOeaKCHNV5KDOqpGA9QFtVha/Ff1YhwB+9O+zM7nV8rY9pMJKGipedQzY0kwL7VJ+l8caPdB taimoor@TIMTIAZ-MOBL"
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNtxE89ICie7RcSnbOjYJcD5GhRy+U/ZohGX4B1el5UzA6A80m5DR9M0bCWMShumk8bWMoNJwgDbzEhMgAzoku6lxE/KMQnvRuJTm3vwpVbS9YSlktgUfxCIM8jG/CHuBma2p/Iw10mfcJmzVRYQJNwimW+7B3ZaXPXpI6jkJqpB0VuYRG0403TilE0ylQyLAXSfrfFo2Cr/DpEmhIZ8VT2FfmMI5QNzIF8jDsisZZjCjwDUsf+M7QfPX92poOoMIbzH227sXc73bjrhhdpLoL61ck09ugfa2Y9LuecD6QLWKe2a+HOub/yhzTQtnFLryYcU235NWSKuev81M35Z8p aghandoura@cslagh"
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcJzwdnMpASjQSKYOJkMuXcVy4dGpNHc1lZg7vxzMiTNrEjtGwKkX57LKKomqcZIFsS37eGCWaRU68pM8NEzozPnm/j6WBe/uK+uWhzClbbQAyQmnb7StDWhwv3Z9j2/fEgquLxvlwfi8MRFsM0PTu3dm2FNMbI1lxXa5zACHbB747lDp65Rqpx2EE4jLtBVm6nPcRaZie9/ikyvHjrGWIekUPgIBhwvaVQJPDtR1ulGZqtu6IC0qGiPowkzzNBj0/BqjnHqx4MuTuNnLROmDzwFX5MrvrwDVw4MyVwwnYqIhdIeOYWSC397stQ0GrQUd5LRhB5lWR8gte5HFBDEyqcC6ut4eMW4Kn9/6x+0cJCGCHnRt2B0a0Xr0MFpRy6ic679eDxhjPwuUFyLh/vaXfNmWUcCuzwIaORSJfG3ifXsH50hs8J0HIUR+o3P++GuRAqkvLw3hxX9y7XNjvTXuX8GGNw/Ms3XrxogrkUewwh/CTTppAYAt03L6xtBde6zc= taimoor@timtiaz-mobl"
  ];

  users.users.sys_cert = {
    isNormalUser = true;
    description = "sys_cert";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };
  users.users.sys_cert.openssh.authorizedKeys.keys = [ ''
from="10.11.170.??,10.11.228.2??,10.11.216.1??,10.108.18.1??,10.108.131.2??,10.109.192.1??,10.108.48.1??,10.109.78.2??,10.109.6.??,10.184.198.49,10.18.59.??,10.11.204.2??,10.11.127.1??,10.4.49.2??,10.18.241.1??,10.63.75.19?,10.63.75.2??,10.4.153.19?,10.4.153.2??,10.63.70.1??,10.64.107.1??,10.108.202.??,10.108.65.19?,10.108.65.2??,10.108.75.??",no-port-forwarding,no-agent-forwarding,no-X11-forwarding ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4EL1Jn5XHHJSflcPyDOqzG2+CV2bPdgoDoSeQC9fltFD2s9WAlgLZl/ysKy+PwpSN3V1PzN+k56kKlUGX65EdPySs8AF5/aEwPD7QvIjoH5zojL3PBn+JdGBQuanGe+jM4ZUov+79pL2LZJNr4yT9qcwS+huNIyo+Ay6wd9cmgYfiZwOktHNZiKsE0OIPYTiviXTtqar58Vu6GeK3tm6esOOWls6iI5GbDYXrYWCNMsiScLClnWNKh0NhEHlubPK2Ezild/pMlOwMCIuKWcbW2b5C6AwdMAPsbvAjKziwPYUGeGlVkqPB/X+X3t9l1Rv5WunxLycv2St09K7twgasnd5XwGrb4iXmMmZIYUgbdXhN84+DgekBLf3/8wASPyBLL0ZCUFCuYxAzEFpQCPGlwYePSF6a90F2mNMDxqOVsAxsTyx6PCPrRn68lpRlAgR5enVlgNI/lIY8FqfT7+eW0Bm3ZuA1xxhGEgiJQQOmas+ICDKCrnlqwTLqEynW/kvcjcyCt//TDGuwOh2KY2+DjjV3gSyWN7niktSTYG0jN7hXf8/OnDM91D4+XgeT3HM/kpDfK03lBuGBeUZa0BPdHXueXr4GxlHg34VtfOM5z9Fsp9Tjv5FmoaHfRNdZLz71JqQitGhQMdPo/osYrbPkmCWnsQKBx7ll5M7uH2OPbQ== 
  '' ];

  # Home Manager
  home-manager = {
    users.intel = import ./home.nix;
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    htop
    dig
    docker-compose
    git
    kubectl
  ];
  environment.localBinInPath = true;

  # passwordless sudo
  security.sudo.extraRules = [
  {  users = [ "intel" ];
      commands = [
         { command = "ALL" ;
           options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];

  # Docker/podman
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
