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

    cpu = {
      type = mkOption {
        type = types.nullOr (types.enum [
          "amd" "intel"
        ]);
        default = null;
        description = "Type of processor.";
      };

      sockets = mkOption {
        type = types.ints.positive;
        default = 1;
        description = "Number of CPU sockets.";
      };

      cores = mkOption {
        type = types.ints.positive;
        default = 1;
        description = "Number of cores per CPU.";
      };

      threads = mkOption {
        type = types.ints.positive;
        default = 1;
        description = "Number of threads per core.";
      };

      support32Bit = mkEnableOption "Processor can run 32-bit apps";
    };

    gpu = {
      enable = mkEnableOption "Has a GPU";
      type = {
        intel = mkEnableOption "Has Intel integrated GPU";
        amd = mkEnableOption "Has AMD dedicated GPU";
        nvidia = mkEnableOption "Has NVIDIA dedicated GPU";
      };
    };

    bluetooth.enable = mkEnableOption "Bluetooth";
    audio.enable = mkEnableOption "Audio";
    battery.enable = mkEnableOption "Battery";
  };

  config = {
    hardware.steam-hardware.enable = true;
    hardware.cpu.amd.updateMicrocode = hwCfg.cpu.type == "amd";
    hardware.cpu.intel.updateMicrocode = hwCfg.cpu.type == "intel";

    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;

    services.tlp.enable = hwCfg.battery.enable;

    hardware.bluetooth = mkIf hwCfg.bluetooth.enable {
      enable = true;
      hsphfpd.enable = true;

      package = pkgs.bluezFull;
    };

    hardware.opengl = mkIf hwCfg.gpu.enable {
      enable = true;
      driSupport = true;
      driSupport32Bit = hwCfg.cpu.support32Bit;
      setLdLibraryPath = true;

      extraPackages = mkIf hwCfg.gpu.enable [
        pkgs.libGL
        pkgs.vaapiIntel      # Video Accel API by Intel
        pkgs.libvdpau-va-gl  # VDPAU driver using VAAPI
        pkgs.vaapiVdpau
        pkgs.vulkan-loader
      ];

      extraPackages32 = mkIf hwCfg.cpu.support32Bit [
        pkgs.pkgsi686Linux.libGL
        pkgs.pkgsi686Linux.vaapiIntel      # Video Accel API by Intel
        pkgs.pkgsi686Linux.libvdpau-va-gl  # VDPAU driver using VAAPI
        pkgs.pkgsi686Linux.vaapiVdpau
        pkgs.pkgsi686Linux.vulkan-loader
      ];
    };

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
