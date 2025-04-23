{ pkgs, inputs, ... }:

  xsession = {
    enable = true;
    windowManager = {
      default = "i3";
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs [
          dmenu
          i3status
        ];
      };
    };
  };

  xdg.configFile."i3/config".source = ./config;
  xdg.configFile."i3status/config".source = ./status.config;
}
