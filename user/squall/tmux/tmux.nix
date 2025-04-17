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
        extraConfig = ''${builtins.readFile ./catppuccin.tmux.conf}'';
      }
      {
        plugin = tmuxPlugins.battery;
        extraConfig = '' '';
      }
      {
        plugin = tmuxPlugins.cpu;
        extraConfig = '' '';
      }
      # leave resurrect & continuum last: https://haseebmajid.dev/posts/2023-07-10-setting-up-tmux-with-nix-home-manager/
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

      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
      run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux
    '';
  };
}
