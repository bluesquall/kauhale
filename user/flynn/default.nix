{ config, pkgs, ... }:

let
  USERNAME = "flynn";
  UID = 4983;
  HASHEDPASSWORD = "$6$frWxIgxN9nL6fg6S$NwQvooXT1KQaCAdh8Q7hxGY0Z2VV9VRxwCwWoLRPDBeTwVr3H7C748NYKgHSViK299C96yebVEs43RAKLGtlQ.";
in
{
  age.secrets.password.file = ./secrets/password.age

  users.users.${USERNAME} = {
    uid = UID;
    home = "/home/${USERNAME}";
    createHome = true;
    isNormalUser = true;
    extraGroups = [ "dialout" "docker" "networkmanager" "wheel" ];
    shell = pkgs.zsh; # keep a POSIX login shell
    # hashedPassword = HASHEDPASSWORD;
    passwordFile = config.age.secrets.password.path;
    # password = builtins.readFile config.age.secrets.password.path;
  };

  home-manager.users.${USERNAME} = import ./home.nix;

}
