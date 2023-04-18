{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovide
    (nerdfonts.override { fonts = [ "FiraCode" "Mononoki" ]; })
    sakura
  ];
}
