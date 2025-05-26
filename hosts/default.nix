{ inputs, nixpkgs, nixpkgs-stable, nixos-hardware, hyprland, home-manager, nixvim, vars, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  laptop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system stable vars hyprland;
      host = {
        hostName = "laptop";
      };
    };
    modules = [
      nixvim.nixosModules.nixvim
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  # This is where i would put my configurations for my desktop at home
}
