{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.foxos;

  cpuCfg = cfg.hardware.cpu;
  totalThreads = cpuCfg.sockets * cpuCfg.cores * cpuCfg.threads;

  isDesktop = cfg.desktop.enable;

  responsiveNiceLevel = 5;
in
{
  config = {
    nix.package = pkgs.nixUnstable;

    nix.daemonNiceLevel = mkIf isDesktop responsiveNiceLevel;
    nix.daemonIONiceLevel = mkIf isDesktop responsiveNiceLevel;

    nix.maxJobs = totalThreads - 1;
    nix.buildCores = totalThreads - 1;

    nix.readOnlyStore = true;
    nix.autoOptimiseStore = true;

    nix.trustedUsers = [ "root" "@wheel" ];

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    nixpkgs.config.allowUnfree = true;
  };
}
