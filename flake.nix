{
  description = "Nixos config flake";

  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    # nix com    extra-substituters = [munity's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ { self, nixpkgs, nixos-hardware, nixpkgs-stable, home-manager, home-manager-stable, nixvim, hyprland, ... }: # Function telling flake which inputs to use
    let
      # Variables Used In Flake
      vars = {
        user = "aske";
        location = "$HOME/.setup";
		terminal = "kitty";
        editor = "nvim";
      };
	
    in {
		nixosConfigurations = (
			import ./hosts {
				inherit (nixpkgs) lib;
				inherit inputs nixpkgs nixpkgs-stable nixos-hardware home-manager nixvim hyprland vars;
			}
		);

		homeConfiguration = (
			import ./nix {
				inherit (nixpkgs) lib;
				inherit inputs nixpkgs nixpkgs-stable home-manager vars;
			}
      	);
	};
}
