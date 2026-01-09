{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }:
  let
    system = "x86_64-linux";
    
    # Helper function to create a host configuration
    mkHost = hostname: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit unstable; };
      modules = [
        # Host-specific configuration
        ./hosts/${hostname}
        
        # Allow unfree packages
        ({ ... }: {
          nixpkgs.config.allowUnfree = true;
        })

        # Unstable packages overlay
        ({ pkgs, ... }:
          let
            unstablePkgs = import unstable {
              inherit system;
              config.allowUnfree = true;
            };
          in {
            environment.systemPackages = [
              unstablePkgs.vscode
            ];
          }
        )

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

