
{ config, lib, ... }:

with lib;
let cfg = config.desktop; 
in {
  options = {
    desktop.enable = mkEnableOption "Enable Desktop filesystems";
  };
  config = lib.mkIf cfg.enable {
# Mount disks
    fileSystems."/data/disk160" = { 
      device = "/dev/disk/by-uuid/44da1a2d-4995-4633-821f-ddc1e25b7f15";
      fsType = "ext4";
    };
    fileSystems."/data/disk2T" = {
      device = "/dev/disk/by-uuid/b02db420-4d64-4ac9-8140-13a9db5fd477";
      fsType = "ext4";
    };
  };
}

