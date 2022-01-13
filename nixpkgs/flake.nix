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
          home = {
            sessionVariables = {
              PAGER = "less";
              EDITOR = "nvim";
              VISUAL = "nvim";
            };
            packages = with pkgs; [
              curl
              dejavu_fonts
              inconsolata
              less
              podman
              st # TODO: Include clipboard, scrollback, & solarized patches.
              tree
            ];
          }; # configuration
        };
        system = "x86_64-linux";
        homeDirectory = "/home/flynn"; # TODO: infer
        username = "flynn"; # TODO: infer
        stateVersion = "22.05";
      };
    };
  };
}
