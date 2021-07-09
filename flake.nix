{
  description = "Personal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager";
    mozilla = { url = "github:Slabity/nixpkgs-mozilla"; flake = false; };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    neovim.url = "github:neovim/neovim?dir=contrib";
  };

  outputs = { self, home-manager, nixos-hardware, mozilla, neovim, nixpkgs, ... }:
  {
    nixosModules = {
      foxos = ./nixos-modules;
    };

    nixosConfigurations = with self; {
      mew = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-amd
          nixosModules.foxos
          ./hosts/mew.nix
          ({
            nixpkgs.overlays = [
              (import mozilla)
              neovim.overlay
              overlays.personal
            ];

            system.extraSystemBuilderCmds = ''
              mkdir -pv $out/overlays
              ln -sv ${mozilla} $out/overlays/mozilla
              ln -sv ${neovim} $out/overlays/neovim
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
