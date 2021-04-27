{ config, lib, pkgs, modulesPath, ... }:

let
  username = "flynn";
  uid = 1982;
  hostname = "encom";
in
{
  imports = [
    ./filesystems.nix
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  nixpkgs.config.allowUnfree = true;

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ];
    };
  };

  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "kvm-amd" "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = hostname;
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
      videoDrivers = [ "amdgpu" "radeon" "nvidia" "vesa" "modesetting" ];
      # ^ These are tried in order until finding one that supports the GPU.
      displayManager = {
        sddm.enable = true;
        autoLogin = {
          enable = true;
          user = username;
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

  environment.systemPackages = with pkgs; [ bash curl zsh ];

  fonts.fonts = with pkgs; [ dejavu_fonts inconsolata ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  users = {
    mutableUsers = false;
    users.${username} = {
      uid = uid;
      home = "/home/${username}";
      createHome = true;
      isNormalUser = true;
      extraGroups = [ "dialout" "docker" "networkmanager" "wheel" ];
      shell = pkgs.zsh; # keep a POSIX login shell
      passwordFile = "/home/.keys/${username}"; # <<=== echo "$(mkpasswd -m sha512crypt)" > /home/.keys/${username}
      openssh.authorizedKeys.keys = [
      ];
    };
  };

  system.stateVersion = "20.09";
}
