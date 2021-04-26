{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  boot.kernelModules = [ "kvm-intel" ];

  nixpkgs.config.allowUnfree = true;
  # ^ required for hardware.enableAllFirmware = true

  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
