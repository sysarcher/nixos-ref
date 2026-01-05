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
      device = "/dev/disk/by-uuid/44da1a2d-4995-4633-821f-ddc1e25b7f15";
      fsType = "ext4";
    };
    
    fileSystems."/data/disk2T" = mkIf (config.networking.hostName == "hp") {
      device = "/dev/disk/by-uuid/b02db420-4d64-4ac9-8140-13a9db5fd477";
      fsType = "ext4";
    };
  };
}
