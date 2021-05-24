{
  description = "Personal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager.url = "github:nix-community/home-manager";
    mozilla = { url = "github:mozilla/nixpkgs-mozilla"; flake = false; };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, home-manager, nixos-hardware, mozilla, nixpkgs, ... }:
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
            nixpkgs.overlays = [
              overlays.personal
              (import mozilla)
            ];

            nix.nixPath = [
              "nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
              "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
              "nixpkgs-overlays=/run/current-system/overlays"
            ];

            system.extraSystemBuilderCmds = ''
              mkdir -pv $out/overlays
              ln -sv ${mozilla} $out/overlays/mozilla
              ln -sv ${./personal-overlay} $out/overlays/personal
            '';
          })
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.slabity = {
              imports = [ ./home-manager ];
            };
          }
        ];
      };
    };

    overlays = {
      personal = import ./personal-overlay;
    };
  };
}
