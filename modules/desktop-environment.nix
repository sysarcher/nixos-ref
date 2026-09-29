{ config, lib, pkgs, ... }:

with lib;
let cfg = config.desktop; 
in {
  options = {
    desktop.enable = mkEnableOption "Enable Desktop environment and filesystems";
  };
  
  config = mkIf cfg.enable {
    # X11 windowing system
    services.xserver.enable = true;

    # GNOME Desktop Environment
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Keymap configuration
    console.useXkbConfig = true;
    services.xserver.xkb = {
      layout = "us";
      variant = "";
      options = "caps:swapescape";
    };

    # Sound with pipewire
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Wacom/Drawing tablet
    hardware.opentabletdriver.enable = true;

    # Host-specific disk mounts (example for hp host)
    fileSystems."/data/disk160" = mkIf (config.networking.hostName == "hp") {
      device = "/dev/disk/by-uuid/00f2ebe8-9512-4e76-948b-3eb5c2ef2f91";
      fsType = "btrfs";
      options = [ "compress=zstd:3" "noatime" ];
    };
    
    fileSystems."/data/disk2T" = mkIf (config.networking.hostName == "hp") {
      device = "/dev/disk/by-uuid/b02db420-4d64-4ac9-8140-13a9db5fd477";
      fsType = "ext4";
    };
  };
}
