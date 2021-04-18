# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let unstableTarball = fetchTarball https://github.com/NixOS/nikpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # The next one requires the one after it
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "@HOSTNAME@"; # Define your hostname.
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
          user = "@USER@";
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

  users = {
    mutableUsers = false;
    users.@USER@ = {
      uid = @UID@;
      home = "/home/@USER@";
      createHome = true;
      isNormalUser = true;
      extraGroups = [ "dialout" "docker" "networkmanager" "wheel" ];
      shell = pkgs.zsh; # keep a POSIX login shell
      passwordFile = "/home/.keys/@USER@";
      # ^ echo "$(mkpasswd -m sha512crypt)" > /home/.keys/@USER@
      openssh.authorizedKeys.keys = [
      ];
    };
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [ zsh curl git tmux neovim brightnessctl docker ];
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
    };
  };

  fonts.fonts = with pkgs; [
    dejavu_fonts
    inconsolata
    iosevka
    monoid
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    # tamsyn
    tamzen
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "20.09";

}

