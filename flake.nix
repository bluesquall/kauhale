# flake.nix
{
  description = "group of houses comprising a home";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    rust-overlay.url = "github:oxalica/rust-overlay";

    agenix.url = "github:yaxitech/ragenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, agenix, rust-overlay, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
      # forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
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
            settings = {
              auto-optimise-store = true;
              experimental-features = "nix-command flakes recursive-nix";
            };
          };

          nixpkgs = {
            config = {
              allowUnfree = true;
              allowUnfreePredicate = (_: true);
            };
            overlays = [ agenix.overlays.default ];
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
    in
    rec {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );
      overlays = import ./overlays { inherit inputs; };

      homeConfigurations = {
        squall = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./user/squall/home.nix ];
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "squall@echo" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./user/squall/home.nix
            ./user/squall/echo.nix
          ];
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };

      nixosConfigurations = {
        iso = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = kahua ++ [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ];
        };
        plasmaIso = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = kahua ++ [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix"
          ];
        };
        example = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./os/example ];
          # modules = [ ./os/example ./user/squall ];
        };
        nimrod = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = kahua ++ [ ./os/nimrod ./user/squall ];
        };
      };
    };
}
