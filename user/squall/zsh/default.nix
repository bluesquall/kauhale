{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    #defaultKeymap = "vicmd"; # <-- enabling this spews help at startup
    initContent = ''
      ${builtins.readFile ./nvims.zsh}
      ${builtins.readFile ./su2.zsh}
      ${builtins.readFile ./vcs.zsh}
      ${builtins.readFile ./path.zsh}

      eval "$(starship init zsh)"
    '';
    history = {
      ignoreSpace = true;
      share = true;
    };
  };

  programs = {
    fzf.enableZshIntegration = true;
    starship.enableZshIntegration = true;
  };

  services.gpg-agent.enableZshIntegration = true;
}
