{ config, pkgs, inputs, ... }:

{
  programs.wezterm = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.wezterm;
    enableBashIntegration = true;
    # enableFishIntegration = true;
    enableZshIntegration = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
