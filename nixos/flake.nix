# flake.nix
{
  description = "kauhale-NixOS";
  inputs.nixos.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = { self, nixos }: {

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
         ({ ... }: { imports = [ ./configuration.nix ] }) 
        ];
      };
    };
  };
}
