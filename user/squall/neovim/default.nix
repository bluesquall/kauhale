{ pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      ${builtins.readFile ./init.vim}
    '';
  };


  xdg.configFile."AstroNvim" = {
    source = ./AstroNvim;
    recursive = true;
  };
}
