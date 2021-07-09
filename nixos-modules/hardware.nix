{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.foxos;
  hwCfg = cfg.hardware;
in
{
  options.foxos.hardware = {
    virtual = mkEnableOption "Virtual hardware support";
    efi = mkEnableOption "Uses EFI for boot";
    gpu.enable = mkEnableOption "GPU";
    audio.enable = mkEnableOption "Audio";
    bluetooth.enable = mkEnableOption "Bluetooth";
  };

  config = {
    hardware.steam-hardware.enable = true;
    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;

    hardware.bluetooth = mkIf hwCfg.bluetooth.enable {
      enable = true;
      hsphfpd.enable = true;
      package = pkgs.bluezFull;
    };

    hardware.opengl = mkIf hwCfg.gpu.enable {
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];

      extraPackages32 = with pkgs.driversi686Linux; [
        amdvlk
      ];
    };

    sound.enable = hwCfg.audio.enable;

    services.pipewire = mkIf hwCfg.audio.enable {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      socketActivation = true;
    };

    boot.loader.efi = mkIf hwCfg.efi {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    boot.loader.grub = mkIf hwCfg.efi {
      efiSupport = true;
      device = "nodev";
    };

    services.udev.extraRules = ''
      # Enable BFQ IO Scheduling algorithm
      ACTION=="add|change", KERNEL=="[sv]d[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
      ACTION=="add|change", KERNEL=="[sv]d[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
      ACTION=="add|change", KERNEL=="nvme[0-9]n1", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"

      # Ultimate Hacking Keyboard rules
      # These are the udev rules for accessing the USB interfaces of the UHK as non-root users.
      SUBSYSTEM=="input", GROUP="input", MODE="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", MODE:="0666", GROUP="plugdev"
      KERNEL=="hidraw*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", MODE="0666", GROUP="plugdev"

      # DualShock 3 controller, Bluetooth
      KERNEL=="hidraw*", KERNELS=="*054C:0268*", MODE="0660", TAG+="uaccess"
      # DualShock 3 controller, USB
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0268", MODE="0660", TAG+="uaccess"
    '';
  };
}
