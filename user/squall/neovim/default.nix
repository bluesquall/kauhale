{ pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = false;
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
  xdg.configFile."LazyVim" = {
    source = ./LazyVim;
    recursive = true;
  };
}
