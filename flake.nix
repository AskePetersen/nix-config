{
  description = "Nixos config flake";

	nixConfig = {
	  extra-substituters = [
		"https://cache.nixos.org"
		"https://nix-community.cachix.org"
		"https://hyprland.cachix.org"
		"https://nixpkgs-unfree.cachix.org"
	  ];
	  extra-trusted-public-keys = [
		"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
		"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
		"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
		"nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
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
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # hyprland = {
    #   url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # };
	#
	# hyprland = {
	#   url = "github:hyprwm/Hyprland/v0.44.1"; # Replace with desired version
	#   inputs.nixpkgs.follows = "nixpkgs";
	# };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ { self, nixpkgs, nixos-hardware, nixpkgs-stable, home-manager, home-manager-stable, nixvim, ... }: # Function telling flake which inputs to use
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
				inherit inputs nixpkgs nixpkgs-stable nixos-hardware home-manager nixvim vars;
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
