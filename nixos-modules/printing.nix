{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.foxos;
  printCfg = cfg.printing;
in
  {
    options.foxos.printing.enable = mkEnableOption "Enable CUPS printing support";

    config = mkIf printCfg.enable {
      services.printing.enable = true;
      services.printing.drivers = with pkgs; [
        gutenprint
        gutenprintBin
        cupsBjnp
        mfcj470dw-cupswrapper
        mfcj6510dw-cupswrapper
        mfcl2700dncupswrapper
      ];
    };
  }
