{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    extraConfig = "
      set-option -g allow-rename off
      set-option -g status-position top
    ";
  };
}
