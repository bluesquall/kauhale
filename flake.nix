# flake.nix
{
  description = "group of houses comprising a home";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    rust-overlay.url = "github:oxalica/rust-overlay";

    agenix.url = "github:yaxitech/ragenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, rust-overlay, agenix, home-manager, ... }:
  let # Wil says to put a let block in so we can do all our pre-calculated stuff at the top. TODO clarify
    lib = nixpkgs.lib;
    system = "x86_64-linux"; # TODO explore ways to generalize, at least to arm64
    overlays = [ rust-overlay.overlays.default agenix.overlays.default ];

    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    kahua = [
      agenix.nixosModules.age
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        # ^otherwise pure evaluation fails for flakes
        home-manager.useUserPackages = true;
      }
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
        programs.zsh.enable = true;
        environment = {
          shells = with pkgs; [ bash zsh ];
          systemPackages = with pkgs; [ age agenix cryptsetup curl git less neovim tmux tree qrencode ];
        };
      })
    ]; # kahua

    kauhale = [
      ({
        nixpkgs.overlays = [
          rust-overlay.overlays.default
          agenix.overlays.default
        ];
      }) # <-- This looks redundant with the overlays inherited above. Is it necessary?
    ]; # kauhale

  in {
    homeConfigurations = {
      squall = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = kauhale ++ [ ./user/squall/home.nix ];
        # extraSpecialArgs = { inherit inputs outputs; };
      };
      "squall@echo" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = kauhale ++ [
          ./user/squall/home.nix
          ./user/squall/echo.nix
        ];
        # extraSpecialArgs = { inherit inputs outputs; };
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
