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
    homeManagerConfigurations = {
      "flynn" = homeManager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/flynn"; # TODO: infer
        username = "flynn"; # TODO: infer
        configuration = { imports = [ ./home.nix ]; };
      };
    };
  };
}
