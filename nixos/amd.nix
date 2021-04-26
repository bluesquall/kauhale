{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  nixpkgs.config.allowUnfree = true;
  # ^ required for hardware.enableAllFirmware = true

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ];
    };
  };
}
