let
  pkgs = import <nixpkgs> {};
  kauhale = [
    fish
    git
    i3
    nvim
    tmux
    zsh

    pkgs.curl
    pkgs.direnv
    pkgs.gnupg
    pkgs.nix
    pkgs.pass
    pkgs.tree
    pkgs.xclip
  ];

#  fish = import ./fish (with pkgs; { inherit makeWrapper symlinkJoin writeText; fish = pkgs.fish; });
  fish = pkgs.fish;
  git = import ./git ({ inherit (pkgs) sources runCommand makeWrapper symlinkJoin writeTextFile; git = pkgs.git; });
  i3 = pkgs.i3;
  nvim = pkgs.neovim;
  tmux = import ./tmux (with pkgs; { inherit makeWrapper symlinkJoin writeText; tmux = pkgs.tmux; });
  zsh = pkgs.zsh;

in
  if pkgs.lib.inNixShell
  then pkgs.mkShell { buildinputs = kauhale; }
  else kauhale

