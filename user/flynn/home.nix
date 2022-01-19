{ pkgs, ... }:

{
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
  };

  programs = {

    gpg.enable = true;

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
