{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.foxos;
  desktopCfg = cfg.desktop;
  waylandCfg = desktopCfg.wayland;

  startsway = pkgs.writeTextFile {
    name = "startsway";
    destination = "/bin/startsway";
    executable = true;
    text = ''
    #! ${pkgs.bash}/bin/bash

    # first import environment variables from the login manager
    systemctl --user import-environment
    # then start the service
    exec systemctl --user start sway.service
    '';
  };
in
  {
    options.foxos.desktop.wayland = {
      enable = mkEnableOption "Enable Wayland instead of Xorg";
    };

    config = mkIf waylandCfg.enable {
      programs.sway = {
        enable = true;
        extraPackages = with pkgs; [
          swaylock # lockscreen
          swayidle

          flashfocus # Simple window animations

          xwayland # for legacy apps

          waybar # status bar
          mako # notification daemon
          kanshi # autorandr

          # GTK settings
          gtk-engine-murrine
          gtk_engines
          gsettings-desktop-schemas
          lxappearance
        ];

        wrapperFeatures = {
          base = true;
          gtk = true;
        };
      };

      programs.waybar.enable = true;

      environment.systemPackages = with pkgs; [
        startsway
      ];

      systemd.user.targets.sway-session = {
        description = "Sway compositor session";
        documentation = [ "man:systemd.special(7)" ];
        bindsTo = [ "graphical-session.target" ];
        wants = [ "graphical-session-pre.target" ];
        after = [ "graphical-session-pre.target" ];
      };

      systemd.user.services.sway = {
        description = "Sway - Wayland window manager";
        documentation = [ "man:sway(5)" ];
        bindsTo = [ "graphical-session.target" ];
        wants = [ "graphical-session-pre.target" ];
        after = [ "graphical-session-pre.target" ];

        # We explicitly unset PATH here, as we want it to be set by
        # systemctl --user import-environment in startsway
        environment.PATH = lib.mkForce null;
        serviceConfig = {
          Type = "simple";
          ExecStart = ''
            ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
          '';
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  }
