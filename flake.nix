{
  description = "NixOS config";

  nixConfig = {
    extra-trusted-substituters = [ "https://cache.flox.dev" ];
    extra-trusted-public-keys = [ "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flox = {
      url = "github:flox/flox/v1.18.0";
    };

    hermes = {
      url = "github:NousResearch/hermes-agent";
    };

    nix-openclaw = {
      url = "github:openclaw/nix-openclaw";
    };
  };

  outputs = { self, nixpkgs, unstable, home-manager, flox, hermes, nix-openclaw, ... }:
  let
    system = "x86_64-linux";
    hermesAgent = hermes.packages.${system}.default;
    
    # Helper function to create a host configuration
    mkHost = hostname: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit unstable flox; };
      modules = [
        # Flox
        # flox.nixosModules.flox

        # Host-specific configuration
        ./hosts/${hostname}
        
        # Allow unfree packages
        ({ ... }: {
          nixpkgs.config.allowUnfree = true;
        })

        ({ ... }: {
          nix.settings.substituters = [
            "https://cache.flox.dev"
          ];
          nix.settings.trusted-public-keys = [
            "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
          ];
         })

        # nix-openclaw overlay: supplies pkgs.openclaw (2026.9.5, not the
        # insecure nixpkgs build) plus pkgs.openclawPackages. It has to be
        # applied here, at the system level, because home-manager runs with
        # useGlobalPkgs = true and therefore shares this pkgs set.
        ({ ... }: {
          nixpkgs.overlays = [ nix-openclaw.overlays.default ];
        })

        ({ pkgs, ... }: {
          environment.systemPackages = with pkgs; [
            flox.packages.${system}.default
          ];
         })

        # Home manager configuration
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit unstable hermes nix-openclaw; };
          home-manager.users.taimoor = import ./home.nix;
        }
      ];
    };
  in {
    packages.${system} = {
      hermes-agent = hermesAgent;
      default = hermesAgent;
    };

    nixosConfigurations = {
      # Define your hosts here
      hp = mkHost "hp";
      xps = mkHost "xps";
      
      # Example: Add more hosts like this:
      # laptop = mkHost "laptop";
      # server = mkHost "server";
    };
  };
}
