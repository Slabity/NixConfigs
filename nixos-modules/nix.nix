{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.foxos;
  responsiveNiceLevel = 5;
in
{
  config = {
    nix.package = pkgs.nixUnstable;

    nix.daemonNiceLevel = 6;
    nix.daemonIONiceLevel = 6;

    nix.gc.automatic = true;
    nix.optimise.automatic = true;

    nix.trustedUsers = [ "root" "@wheel" ];

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    nix.nixPath = [
      "nixos-config=/nix/var/nix/profiles/per-user/root/channels"
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixpkgs-overlays=/run/current-system/overlays"
    ];

    nixpkgs.config.allowUnfree = true;
  };
}
