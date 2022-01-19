{ pkgs, ... }:

let
  USERNAME = "flynn";
  UID = 4983;
  # PASSWORD = "change_me";
  HASHEDPASSWORD = "$6$frWxIgxN9nL6fg6S$NwQvooXT1KQaCAdh8Q7hxGY0Z2VV9VRxwCwWoLRPDBeTwVr3H7C748NYKgHSViK299C96yebVEs43RAKLGtlQ.";
in
{
  users.users.${USERNAME} = {
    uid = UID;
    home = "/home/${USERNAME}";
    createHome = true;
    isNormalUser = true;
    extraGroups = [ "dialout" "docker" "networkmanager" "wheel" ];
    shell = pkgs.zsh; # keep a POSIX login shell
    # password = PASSWORD;
    hashedPassword = HASHEDPASSWORD;
  };

  home-manager.users.${USERNAME} = { pkgs, ... }: {
    imports = [ ./home.nix ];
    home.username = USERNAME;
    home.homeDirectory = "/home/${USERNAME}";
  };

};
