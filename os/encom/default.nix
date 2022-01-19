{ config, lib, pkgs, modulesPath, ... }:

let
  USERNAME = "flynn";
  UID = 4983;
  PASSWORD = "change_me";
  HASHEDPASSWORD = "to-do";
  HOSTNAME = "encom";
in
{
  imports = [
    ./filesystems.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  hardware = {
    # enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };
    video.hidpi.enable = lib.mkDefault true;
  };

  boot = {
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = HOSTNAME;
    useDHCP = false;
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "US/Pacific";

  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      dpi = 180;
      layout = "us";
      libinput.enable = true;
      videoDrivers = [ "vesa" "modesetting" ];
      # ^ These are tried in order until finding one that supports the GPU.
      displayManager = {
        sddm.enable = true;
        autoLogin = {
          enable = true;
          user = USERNAME;
        };
        defaultSession = "none+i3";
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [ dmenu i3status ];
      };
    };
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [ bash curl git xterm zsh ];

  users.mutableUsers = false;
  
  system.stateVersion = "22.05";
}
