# flake.nix
{
  description = "kauhale-NixOS";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixos";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos";
    };

    # utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = inputs@{ self, nixos, agenix, home-manager }: {

    nixosConfigurations = let
      kahua = {
        system = "x86_64-linux";
        modules = [
          ({ lib, pkgs, ... }: {
            networking = {
              networkmanager.enable = true;
              wireless.enable = lib.mkForce false;
              # ^because WPA Supplicant cannot run with NetworkManager
            };
            environment = {
              systemPackages = with pkgs; [ age bash curl git less neovim tree zsh ];
              
            };
          })
        ];
      };
    in {
      minimalIso = nixos.lib.nixosSystem {
        inherit (kahua) system;
        modules = kahua.modules ++ [
          "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      };
      plasmaIso = nixos.lib.nixosSystem {
        inherit (kahua) system;
        modules = kahua.modules ++ [
          "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix"
        ];
      };
      kauhale = nixos.lib.nixosSystem {
        inherit (kahua) system;
        modules = kahua.modules ++ [
          home-manager.nixosModules.home-manager
          ./configuration.nix
        ];
      };
    };
  };
}
