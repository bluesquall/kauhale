{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    #defaultKeymap = "vicmd"; # <-- enabling this spews help at startup
    initExtra = ''
      ${builtins.readFile ./nvims.zsh}
      ${builtins.readFile ./su2.zsh}
      ${builtins.readFile ./vcs.zsh}
      ${builtins.readFile ./path.zsh}
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
  services.gpg-agent.enableZshIntegration = true;
}
