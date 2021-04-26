{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nikpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports = [
    ./args.nix
    ./filesystems.nix
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
  ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = ${config.args.hostname};
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
          user = ${config.args.username};
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

  programs.gnupg.agent = { # <--TODO: enable in home-manager instead?
    enable = true;
    enableSSHSupport = true;
  };

  users = {
    mutableUsers = false;
    users.${config.args.username} = {
      uid = ${config.args.uid};
      createHome = true;
      isNormalUser = true;
      extraGroups = [ "dialout" "docker" "networkmanager" "wheel" ];
      shell = pkgs.zsh; # keep a POSIX login shell
      passwordFile = "/home/.keys/${config.args.username}";
      # ^ echo "$(mkpasswd -m sha512crypt)" > /home/.keys/${config.args.username}
      openssh.authorizedKeys.keys = ${config.args.pubkeys};
    };
  };

  system.stateVersion = "20.09";
}
