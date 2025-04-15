{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    clock24 = true;

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'frappe'
          set -g @catppuccin_window_tabs_enabled on
          set -g @catppuccin_date_time "%H:%M"
        '';
      }
    ];

    extraConfig = "
set -g allow-rename off
set -g status-position top
    ";
  };
}
