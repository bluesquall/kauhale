# flake.nix
{
  description = "group of houses comprising a home";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    systems.url = "github:nix-systems/default";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    nixgl.url   = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.inputs.flake-utils.follows = "flake-utils";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.systems.follows = "systems";
    agenix.inputs.home-manager.follows = "home-manager";

    ragenix.url = "github:yaxitech/ragenix";
    ragenix.inputs.nixpkgs.follows = "nixpkgs";
    ragenix.inputs.agenix.follows = "agenix";
    ragenix.inputs.flake-utils.follows = "flake-utils";
    ragenix.inputs.rust-overlay.follows = "rust-overlay";

  };

  outputs = { nixpkgs, systems, flake-utils, nixgl,
    rust-overlay, home-manager, agenix, ragenix, ... }:
  let # Wil says to put a let block in so we can do all our pre-calculated stuff at the top. TODO clarify
    lib = nixpkgs.lib;
    system = "x86_64-linux"; # TODO explore ways to generalize, at least to arm64
    overlays = [ ragenix.overlays.default ];

    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    kahua = [
      ragenix.nixosModules.age
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        # ^otherwise pure evaluation fails for flakes
        #  & overlays don't propogate to home-manager
      }
      ({ lib, pkgs, ... }: {
        nix = {
          package = pkgs.nixUnstable;
          settings = {
              auto-optimise-store = true;
              experimental-features = "nix-command flakes recursive-nix";
            };
        };

        networking = {
          networkmanager.enable = true;
          wireless.enable = lib.mkForce false;
          # ^because WPA Supplicant cannot run with NetworkManager
        };
        programs.zsh.enable = true;
        environment = {
          shells = with pkgs; [ bash zsh ];
          systemPackages = with pkgs; [ age agenix cryptsetup curl git less neovim tmux tree qrencode ];
        };
      })
    ]; # kahua

  in {
    homeConfigurations = {
      squall = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ agenix.overlays.default ];
        };
        modules = [
          ./user/squall/home.nix
        ];
        extraSpecialArgs = {
          nixgl = nixgl;
        };
      };
    };

    nixosConfigurations = {

      iso = lib.nixosSystem {
        inherit pkgs system;
        modules = kahua ++ [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      };

      plasmaIso = lib.nixosSystem {
        inherit pkgs system;
        modules = kahua ++ [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix"
        ];
      };

      nimrod = lib.nixosSystem {
        inherit pkgs system;
        modules = kahua ++ [ ./os/nimrod ./user/squall ];
      };

    };
  };
}
