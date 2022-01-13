{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, homeManager }: {
    homeConfigurations = {
      "flynn@encom" = homeManager.lib.homeManagerConfiguration {
        configuration = {pkgs, ...}: {
          programs.home-manager.enable = true;
          home.packages = [ pkgs.hello ];
        };
        system = "x86_64-linux";
        homeDirectory = "/home/flynn"; # TODO: infer
        username = "flynn"; # TODO: infer
        stateVersion = "22.05";
      };
    };
  };
}
