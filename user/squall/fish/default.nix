{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    
    interactiveShellInit = ''
set fish_greeting # get rid of the greeting
    '';
  };
  programs.starship.enableFishIntegration = true;
}


