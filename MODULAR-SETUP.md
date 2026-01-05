# Modular NixOS Configuration

This repository contains a modular NixOS configuration that can be easily adapted for multiple devices.

## Directory Structure

```
.
├── flake.nix                    # Main flake configuration with host definitions
├── home.nix                     # Home-manager configuration
├── hosts/                       # Host-specific configurations
│   ├── hp/                      # Desktop host
│   │   ├── default.nix          # Host configuration
│   │   └── hardware-configuration.nix
│   └── laptop/                  # Laptop host (example)
│       ├── default.nix          # Host configuration
│       └── hardware-configuration.nix
└── modules/                     # Shared modules
    ├── system.nix               # Common system configuration
    ├── desktop-environment.nix  # Desktop environment (GNOME)
    └── virtualization.nix       # Docker and KVM configuration
```

## Adding a New Device

### 1. Create Host Directory

```bash
mkdir -p hosts/my-new-device
```

### 2. Generate Hardware Configuration

On the new device, run:

```bash
nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
```

Copy the generated file to `hosts/my-new-device/hardware-configuration.nix`

### 3. Create Host Configuration

Create `hosts/my-new-device/default.nix`:

```nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/desktop-environment.nix  # Optional: Remove if no GUI needed
    ../../modules/virtualization.nix       # Optional: Remove if no Docker/KVM needed
  ];

  # Host-specific settings
  networking.hostName = "my-new-device";
  
  # Enable/disable desktop environment
  desktop.enable = true;  # Set to false for servers
  
  # Add any device-specific configuration here
  
  system.stateVersion = "24.05";
}
```

### 4. Register Host in flake.nix

Add your new host to the `nixosConfigurations` in `flake.nix`:

```nix
nixosConfigurations = {
  hp = mkHost "hp";
  laptop = mkHost "laptop";
  my-new-device = mkHost "my-new-device";  # Add this line
};
```

### 5. Build and Deploy

```bash
# Build the configuration
sudo nixos-rebuild build --flake .#my-new-device

# Test the configuration
sudo nixos-rebuild test --flake .#my-new-device

# Apply the configuration permanently
sudo nixos-rebuild switch --flake .#my-new-device
```

## Modules

### system.nix
Contains common system configuration that applies to all hosts:
- Nix settings (experimental features, garbage collection)
- Network configuration
- Time zone and locale
- Common services (SSH, Tailscale, printing)
- User accounts
- System packages
- Fonts

### desktop-environment.nix
Contains desktop environment configuration:
- X11 and GNOME setup
- Audio (PipeWire)
- Input devices (keyboard, drawing tablet)
- Host-specific disk mounts (currently for hp host)

### virtualization.nix
Contains virtualization configuration:
- Docker
- KVM/QEMU with libvirt

## Customization Tips

### Device-Specific Packages
Add packages specific to a device in its `default.nix`:

```nix
environment.systemPackages = with pkgs; [
  device-specific-package
];
```

### Conditional Modules
Import modules conditionally based on device needs:

```nix
imports = [
  ./hardware-configuration.nix
  ../../modules/system.nix
  # Only import desktop for non-server hosts
] ++ lib.optionals config.desktop.enable [
  ../../modules/desktop-environment.nix
];
```

### Override Module Settings
Override settings from modules in your host configuration:

```nix
# Disable a service from system.nix
services.tailscale.enable = lib.mkForce false;
```

## Migration from Old Structure

The old files are still present for reference:
- `configuration.nix` - Original monolithic configuration
- `host-setup.nix` - Old host-specific settings
- `desktop.nix` - Old desktop module

These can be safely removed once you've verified the new structure works.

## Building on Current Device (hp)

```bash
sudo nixos-rebuild switch --flake .#hp
```

## Troubleshooting

### Flake Update
If you need to update inputs:

```bash
nix flake update
```

### Check Configuration
Validate your configuration without applying:

```bash
nixos-rebuild build --flake .#my-new-device
```

### View Available Hosts
List all configured hosts:

```bash
nix flake show
```
