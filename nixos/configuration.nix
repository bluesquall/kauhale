# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let unstableTarball = fetchTarball https://github.com/NixOS/nikpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable = import unstableTarball {
          config = config.nixpkgs.config;
        };
      };
    };
    # overlays = [];
  };


  imports = [
    ./hardware-configuration.nix
    ../settings.nix
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
  ];


  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.enableAllFirmware = true;

  networking = {
    hostName = {config.settings.hostname};
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
      displayManager = {
        sddm.enable = true;
        autoLogin = {
          enable = true;
          user = {config.settings.username};
        };
        defaultSession = "none+i3";
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [ dmenu i3status ];
      };
      layout = "us";
      libinput.enable = true;
    };
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [ zsh curl ];

  fonts.fonts = with pkgs; [ dejavu_fonts inconsolata ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  users = {
    mutableUsers = false;
    users.${config.settings.username}= {
      uid = ${config.settings.uid};
      createHome = true;
      isNormalUser = true;
      extraGroups = [ "dialout" "docker" "networkmanager" "wheel" ];
      shell = pkgs.zsh; # keep a POSIX login shell
      passwordFile = "/home/.keys/{config.settings.username}";
      # ^ echo "$(mkpasswd -m sha512crypt)" > /home/.keys/{config.settings.username}
      openssh.authorizedKeys.keys = [
      ];
    };
  };

  home-manager.users.${config.settings.username} = import ../nixpkgs/home.nix;

  system.stateVersion = "20.09";

}

