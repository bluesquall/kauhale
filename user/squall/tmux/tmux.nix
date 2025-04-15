{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    clock24 = true;
    extraConfig = "
set -g allow-rename off
set -g status-position top
    ";
  };
}
