{ pkgs, config, ... }:
{
  imports = [
    ./hardware.nix
    ./nix.nix
    ./desktop.nix
    ./printing.nix
  ];
}
