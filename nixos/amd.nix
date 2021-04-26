{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ./args.nix ./common.nix ];

  boot.initrd.kernelModules = [ "amdgpu" ]

  hardware = {
    cpu.amd.updateMicrocode = true;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ];
    };
  };
}
