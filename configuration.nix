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
      ./host-setup.nix
      ./desktop.nix
    ];

  # Experimental Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Mount disks
  # imports = [ ./machine-configs.nix ]

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # KVM
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # SSH
  services.openssh.enable = true;

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
  services.pulseaudio.enable = false;
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
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # GPG Agent
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    gnome-software
    tailscale
    zoom-us
    #gnomeExtensions.topicons-plus
    gnomeExtensions.appindicator
    nextcloud-client
    signal-desktop-bin
    vscode
    xournalpp
    kitty
    kitty-themes
    gnome-terminal
    gnome-boxes
    pinentry-curses
    google-chrome
  ];

  fonts.packages = with pkgs; [
    # (nerdfonts.override { fonts = [ "JetBrainsMono" "FantasqueSansMono" ]; })
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.fantasque-sans-mono
  ];

  #services.teamviewer.enable = true;
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.trusted-users = [ "root" "@wheel" "taimoor" ];
  nix.settings.trusted-substituters = [ "https://cache.flox.dev" ];
  nix.settings.trusted-public-keys = [ "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=" ];
  nix.optimise.automatic = true;
}
