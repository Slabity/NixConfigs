{
  description = "Personal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager.url = "github:nix-community/home-manager";
    #nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, home-manager, nixos-hardware, nixpkgs, ... }:
  {
    nixosModules = {
      foxos = ./nixos-modules;
    };

    nixosConfigurations = with self; {
      mew = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixosModules.foxos
          ./hosts/mew.nix
          ({
            nixpkgs.overlays = [ overlays.personal ];
          })
        ];
      };
    };

    overlays = {
      personal = import ./personal-overlay;
    };
  };
}
