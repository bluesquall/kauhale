# flake.nix
{
  description = "group of houses comprising a home";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  # outputs = inputs@{ self, nixpkgs, agenix, home-manager, ... }: {
  #           ^        ^ TODO why do some examples include `self`?
  #           ^ TODO what does this `inputs@` mean?

  outputs = { nixpkgs, agenix, home-manager, ... }:
  let # Wil says to put a let block in so we can do all our pre-calculated stuff at the top. TODO clarify
    lib = nixpkgs.lib;
    
    kahua = { # foundation
      system = "x86_64-linux"; # TODO explore ways to generalize, at least to arm64

      pkgs = import nixpkgs {
        inherit (kahua) system;
        config.allowUnfree = true;
      };

      modules = [
        ({ lib, pkgs, ... }: {
          networking = {
            networkmanager.enable = true;
            wireless.enable = lib.mkForce false;
            # ^because WPA Supplicant cannot run with NetworkManager
          };
          environment = {
            systemPackages = with pkgs; [ age bash curl git less neovim tmux tree zsh ];
          };
        })
      ];

    };
  in {

    homeConfigurations = {
      flynn = home-manager.lib.homeManagerConfiguration {
        inherit (kahua) system pkgs;
        username = "flynn";
        homeDirectory = "/home/flynn";
        configuration = { imports = [ ./home.nix ]; };
      }; # <-- TODO simplify with wrappers later, once understood
    };

    nixosConfigurations = {

      minimalIso = lib.nixosSystem {
        inherit (kahua) system;
        modules = kahua.modules ++ [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      };

      plasmaIso = lib.nixosSystem {
        inherit (kahua) system;
        modules = kahua.modules ++ [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix"
        ];
      };

      kauhale = lib.nixosSystem {
        inherit (kahua) system;
        modules = kahua.modules ++ [
          home-manager.nixosModules.home-manager
          ./os/configuration.nix
        ];
      };

    };
  };
}
