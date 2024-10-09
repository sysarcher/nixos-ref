# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      <home-manager/nixos>
      ./home.nix # Home manager 
    ];

  # Experimental Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Mount disks
  fileSystems."/data/disk160" = { 
    device = "/dev/disk/by-uuid/44da1a2d-4995-4633-821f-ddc1e25b7f15";
    fsType = "ext4";
  };
  fileSystems."/data/disk2T" = {
    device = "/dev/disk/by-uuid/b02db420-4d64-4ac9-8140-13a9db5fd477";
    fsType = "ext4";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Docker
  virtualisation.docker.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # SSH
  services.openssh.enable = true;
  users.users.taimoor.openssh.authorizedKeys.keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDs4sfddTqp1VNEVI62oYJWEjY+YCVQd0D+ws64HcmzeiXBE08WCBKpBa0KaipxJgbJC368R77UDkMRpANcInml73rYd/FtQSBluze8UT8p4RbuFhi+5ehEFeFdhAqxZYz1d1DAfk4hzOvUXsS66BFFHjerRWUanb0QwpMpcnNJbV9pYOP6pPSKBBwHqgd0hZzpC0QWgjhqsazINLWohaapK6ncLpJR7XpJjkmz35FBvW739t5wNqNWDmH1QvMTBMIlT/94CGJN81SQJhydhchsTEqsj/Z2BT+gUsb+y0Us7v3GsjfB84cEC8MzLwQ+JNEzgRAvL8gYCe2eu2BoM1qT /home/taimoor/.ssh/id_rsa"
  ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "caps:swapescape"; # https://unix.stackexchange.com/a/639163
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.sudo.wheelNeedsPassword = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.taimoor = {
    isNormalUser = true;
    description = "taimoor";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    gnome.gnome-software
    tailscale
    zoom-us
    #gnomeExtensions.topicons-plus
    gnomeExtensions.appindicator
    nextcloud-client
    signal-desktop
    vscode
    xournalpp
    kitty
    kitty-themes
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?
}
