{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    # kernelModules = [ "amdgpu" ];
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
