{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    #defaultKeymap = "vicmd"; # <-- enabling this spews help at startup
    initExtra = ''
      ${builtins.readFile ./nvims.zsh}
    '';
    history = {
      ignoreSpace = true;
      share = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "robbyrussell";
    };
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
