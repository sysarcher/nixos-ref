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
      url = "github:flox/flox/v1.13.2";
    };
  };

  outputs = { self, nixpkgs, unstable, home-manager, flox, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    raindrop = pkgs.callPackage ./packages/raindrop.nix { };
    overlay = final: prev: {
      inherit raindrop;
    };
    
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
          nixpkgs.config.permittedInsecurePackages = [
            "openclaw-2026.5.7"
          ];
          nixpkgs.overlays = [ overlay ];
        })

        ({ ... }: {
          nix.settings.substituters = [
            "https://cache.flox.dev"
          ];
          nix.settings.trusted-public-keys = [
            "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
          ];
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
          home-manager.extraSpecialArgs = { inherit unstable; };
          home-manager.users.taimoor = import ./home.nix;
        }
      ];
    };
  in {
    packages.${system} = {
      inherit raindrop;
      default = raindrop;
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
