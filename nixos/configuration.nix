{ config, lib, pkgs, modulesPath, ... }:

let
  USERNAME = "flynn";
  UID = 1982;
  HOSTNAME = "encom";
in
{
  imports = [
    ./filesystems.nix
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz}/nixos"
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
#      extraPackages = with pkgs; [ amdvlk rocm-opencl-icd rocm-opencl-runtime ];
      extraPackages = with pkgs; [ amdvlk ];
    };
    video.hidpi.enable = lib.mkDefault true;
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
      videoDrivers = [ "amdgpu" "vesa" "modesetting" ];
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

  users = {
    mutableUsers = false;
    users.${USERNAME} = {
      uid = UID;
      home = "/home/${USERNAME}";
      createHome = true;
      isNormalUser = true;
      extraGroups = [ "dialout" "docker" "networkmanager" "wheel" ];
      shell = pkgs.zsh; # keep a POSIX login shell
      passwordFile = "/home/.keys/${USERNAME}"; # <<=== echo "$(mkpasswd -m sha512crypt)" > /home/.keys/${USERNAME}
      openssh.authorizedKeys.keys = [
      ];
    };
  };

  # home-manager.users.${USERNAME} = import ./home.nix;

  system.stateVersion = "21.05";
}
