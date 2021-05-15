{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:rycee/home-manager/master";
  };

  outputs = { self, ... }@inputs: {
    homeManagerConfigurations = {
      x = inputs.home-manager.lib.homeManagerConfiguration {
        configuration = ./nixpkgs/home.nix;
        system = "x86_64-linux";
        homeDirectory = "/home/flynn";
        username = "flynn";
      };
    };
  };
}
