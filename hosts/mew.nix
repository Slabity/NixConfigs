{ pkgs, ... }:
{
  system.nixos.label = "mew";

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  foxos.hardware.efi = true;

  foxos.hardware.cpu = {
    type = "amd";
    sockets = 1;
    cores = 8;
    threads = 2;
    support32Bit = true;
  };

  foxos.hardware.gpu.enable = true;
  foxos.hardware.gpu.type.intel = false;
  foxos.hardware.gpu.type.amd = true;

  foxos.hardware.bluetooth.enable = true;
  foxos.hardware.audio.enable = true;
  foxos.hardware.battery.enable = false;

  foxos.desktop.enable = true;
  foxos.desktop.wayland.enable = true;
  foxos.desktop.x11.enable = false;

  time.timeZone = "America/New_York";

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;

    users."slabity" = {
      uid = 1000;
      isNormalUser = true;

      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "libvirtd"
        "dialout"
        "adbusers"
      ];

      passwordFile = "${./passwd}";
    };
  };

  boot.initrd.availableKernelModules = [ "uas" "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" "uinput" ];
  boot.extraModulePackages = [ ];

  fileSystems = let
    btrfsDisk = { device, subvol ? null, ssd ? null }:
    {
      device = device;
      fsType = "btrfs";
      options = if subvol == null then [] else [ "subvol=${subvol}" ];
    };

    mainDisk = "/dev/disk/by-uuid/8e220c5a-93f7-415b-a3fa-ce1f823dd145";
  in {
    "/" = btrfsDisk { device = mainDisk; subvol = "system"; };
    "/home" = btrfsDisk { device = mainDisk; subvol = "data"; };

    "/boot" = {
      device = "/dev/disk/by-uuid/B064-FB62";
      fsType = "vfat";
    };
  };
}
