{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ./args.nix ./common.nix ];

  boot.kernelModules = [ "kvm-intel" ];

  hardware = {
    cpu.intel.updateMicrocode = true;
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  services.xserver.videoDrivers = [ "vesa" "modesetting" ];
}
