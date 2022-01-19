{ config, lib, pkgs, modulesPath, ... }:

let
  USERNAME = "flynn";
  UID = 4983;
  PASSWORD = "change_me";
  HASHEDPASSWORD = "to-do";
in
{
  users.users.${USERNAME} = {
    uid = UID;
    home = "/home/${USERNAME}";
    createHome = true;
    isNormalUser = true;
    extraGroups = [ "dialout" "docker" "networkmanager" "wheel" ];
    shell = pkgs.zsh; # keep a POSIX login shell
    password = PASSWORD;
    # hashedPassword = HASHEDPASSWORD;
  };

  home-manager.users.${USERNAME} = { pkgs, ... } {
    programs.home-manager.enable = true;
    pkgs.config.allowUnfree = true;
    home = {
      sessionVariables = {
        PAGER = "less";
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      packages = with pkgs; [
        brightnessctl
        curl
        dejavu_fonts 
        docker
        inconsolata
        less
      ];
    };

    file = {
      ".Xresources" = {
        target = ".Xresources";
        text = ''
UXTerm*foreground: orange
UXTerm*background: black
UXTerm*renderFont: true
!UXTerm*faceName: inconsolata
UXTerm*faceName: Deja Vu Sans Mono
UXTerm*faceSize: 10

XTerm*selectToClipboard: true
Ctrl Shift <Key>C: copy-selection(CLIPBOARD)
Ctrl Shift <Key>V: insert-selection(CLIPBOARD)
        '';
      };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    tmux.enable = true;

    services = {
      gpg-agent.enable = true;
      ssh-agent.enable = true;
    };
  };
}
