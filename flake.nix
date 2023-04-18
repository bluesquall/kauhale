# flake.nix
{
  description = "group of houses comprising a home";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = { nixpkgs, ragenix, home-manager, ... }:
  let # Wil says to put a let block in so we can do all our pre-calculated stuff at the top. TODO clarify
    lib = nixpkgs.lib;

    kahua = { # foundation

      system = "x86_64-linux"; # TODO explore ways to generalize, at least to arm64

      pkgs = import nixpkgs {
        inherit (kahua) system;
        # config.allowUnfree = true;
      };

      modules = [
        ragenix.nixosModules.age

        ({ lib, pkgs, ... }: {

          nix = {
            package = pkgs.nixUnstable;
            extraOptions = "experimental-features = nix-command flakes recursive-nix";
          };

          networking = {
            networkmanager.enable = true;
            wireless.enable = lib.mkForce false;
            # ^because WPA Supplicant cannot run with NetworkManager
          };

          environment.systemPackages = with pkgs; [ age bash curl git less neovim tmux tree zsh ];

        })
      ];
    }; # kahua

    kauhale = {
      modules = [
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          # ^otherwise pure evaluation fails for flakes
          home-manager.useUserPackages = true;
        }
      ];
    }; # kauhale
  in {

    homeConfigurations = {
      squall = home-manager.lib.homeManagerConfiguration {
	pkgs = nixpkgs.legacyPackages.${kahua.system};
        modules = [ ./user/squall/home.nix ];
	# extraSpecialArgs = { inherit inputs outputs; };
      };
      "squall@echo" = home-manager.lib.homeManagerConfiguration {
	pkgs = nixpkgs.legacyPackages.${kahua.system};
        modules = [ ./user/squall/home.nix ./user/squall/echo.nix ];
	# extraSpecialArgs = { inherit inputs outputs; };
      };
    };

    nixosConfigurations = {

      iso = lib.nixosSystem {
        inherit (kahua) pkgs system;
        modules = kahua.modules ++ [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      };

      plasmaIso = lib.nixosSystem {
        inherit (kahua) pkgs system;
        modules = kahua.modules ++ [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix"
        ];
      };

      nimrod = lib.nixosSystem {
        inherit (kahua) system;
        modules = kahua.modules ++ kauhale.modules ++ [
          ./os/nimrod
          ./user/squall
        ];
      };

    };
  };
}
