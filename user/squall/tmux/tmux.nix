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
        extraConfig = ''${builtins.readFile ./catppuccin.tmux.conf};''
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];

    extraConfig = ''
      ${builtins.readFile ./ux.tmux.conf}
      ${builtins.readFile ./true-color.tmux.conf}
      ${builtins.readFile ./undercurl.tmux.conf}
    '';
  };
}
