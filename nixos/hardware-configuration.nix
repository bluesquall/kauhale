# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-id/dm-name-crypt";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  boot.initrd.luks.devices."crypt".device = "/dev/disk/by-partlabel/luks";

  fileSystems."/boot" =
    { device = "/dev/disk/by-partlabel/EFI";
      fsType = "vfat";
      neededForBoot = true;
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-id/dm-name-crypt";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-id/dm-name-crypt";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-id/dm-name-crypt";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-id/dm-name-crypt";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
