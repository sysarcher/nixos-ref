{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, home-manager,  ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.hp = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix


        ({ ... }: {
          nixpkgs.config.allowUnfree = true;
        })

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


        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.taimoor = import ./home.nix;
        }
      ];
    };
  };
}

