{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ { self, nixpkgs, nixos-hardware, nixpkgs-stable, home-manager, nixvim, hyprland, ... }: # Function telling flake which inputs to use
    let
	  system = "x86_64-linux";
      # Variables Used In Flake
      vars = {
        user = "aske";
        location = "$HOME/.setup";
        editor = "nvim";
      };
    in {
		nixosConfigurations = (
			import ./hosts {
				inherit (nixpkgs) lib;
				inherit inputs nixpkgs nixpkgs-stable nixos-hardware home-manager nixvim hyprland vars;
			}
		);
		homeConfigurations.${vars.user} = home-manager.lib.homeManagerConfiguration {
			inherit system;
			homeDirectory = "/home/${vars.user}";
			username = "${vars.user}";
			configuration = import ./home.nix;
		};
	};
}
