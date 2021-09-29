{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.foxos;
  desktopCfg = cfg.desktop;
  xCfg = desktopCfg.x11;
in
  {
    options.foxos.desktop.x11 = {
      enable = mkEnableOption "Enable Xorg instead of Wayland";
    };

    config = mkIf xCfg.enable {
      services.xserver = {
        enable = true;

        layout = "us";
        libinput = {
          enable = true;
          touchpad = {
            accelProfile = "flat";
            tapping = false;
            tappingDragLock = false;
          };
        };

        displayManager.job.logToJournal = true;
        displayManager.autoLogin = {
          enable = true;
          user = "slabity";
        };

        displayManager.lightdm.enable = true;
        displayManager.lightdm.greeter.enable = false;
        desktopManager.xterm.enable = false;
        useGlamor = true;

        desktopManager.session = [
          {
            name = "custom";
            start = "";
          }
        ];

        displayManager.defaultSession = "custom";
      };
    };
  }
