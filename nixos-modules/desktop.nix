{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.foxos;
  desktopCfg = cfg.desktop;
in
{
  imports = [
    ./x11.nix
    ./wayland.nix
  ];
  options.foxos.desktop = {
    enable = mkEnableOption "Enable desktop support";
  };

  config = mkIf desktopCfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.loader.grub.enable = true;
    boot.loader.grub.useOSProber = true;
    boot.loader.timeout = 3;

    services.dbus.packages = with pkgs; [ gnome3.dconf ];

    services.avahi.enable = true;
    services.mpd.enable = true;

    networking.networkmanager ={
      enable = true;
      packages = with pkgs; [ networkmanager-openvpn ];
      unmanaged = [ "interface-name:ve-*" ];
    };

    fonts.enableDefaultFonts = true;
    fonts.fonts = with pkgs; [
      corefonts source-code-pro source-sans-pro source-serif-pro
      font-awesome-ttf terminus_font powerline-fonts google-fonts inconsolata noto-fonts
      noto-fonts-cjk unifont ubuntu_font_family nerdfonts
    ];
    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = [
        "Terminess Powerline"
        "TerminessTTF Nerd Font Mono"
      ];
      defaultFonts.emoji = [ "Noto Color Emoji" ];
      hinting.enable = true;
      antialias = true;
    };

    xdg = {
      portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-wlr
        ];
        gtkUsePortal = true;
      };
    };

    environment.systemPackages = with pkgs; [
      nix-index
      nix-prefetch-git

      unzip zip unrar

      pciutils usbutils atop
      pstree

      file bc psmisc

      git manpages
    ];
  };
}
