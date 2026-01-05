{ config, pkgs, ... }:

{
  # Experimental Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.networkmanager.enable = true;

  # Time and Locale
  time.timeZone = "Europe/Berlin";
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

  # Services
  services.tailscale.enable = true;
  services.openssh.enable = true;
  services.printing.enable = true;
  services.flatpak.enable = true;

  # XDG Portal
  xdg.portal.enable = true;

  # Security
  security.rtkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # GPG Agent
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # Programs
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [ pkgs.gcc ];

  # User configuration
  users.users.taimoor = {
    isNormalUser = true;
    description = "taimoor";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Garbage collection and optimization
  nix.gc = {
    automatic = true;
    dates = [ "weekly" ];
    options = "--delete-older-than 14d";
  };
  
  nix.optimise = {
    automatic = true;
    dates = [ "monthly" ];
  };

  # Nix settings
  nix.settings.trusted-users = [ "root" "@wheel" "taimoor" ];
  nix.settings.trusted-substituters = [ "https://cache.flox.dev" ];
  nix.settings.trusted-public-keys = [ "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=" ];

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    gnome-software
    tailscale
    zoom-us
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
    direnv
    graphviz
    vlc
    # pyenv dependencies
    gcc
    zlib
    gnumake
    libffi
    readline
    bzip2
    openssl
    ncurses
    pyenv
    xz
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fantasque-sans-mono
  ];
}
