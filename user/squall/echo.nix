{ pkgs, ... }:

{
  home.packages = with pkgs; [
    age
    agenix
    (nerdfonts.override { fonts = [ "FiraCode" "Mononoki" ]; })
    sakura
  ];
}
