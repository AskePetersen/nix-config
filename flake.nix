{
  description = "Nixos config flake";

  nixConfig = {
    # Online caches to download stuff from, shouldn't take up space on ssd
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
    ];
    # I need to pass the public keys to these online caches for nix to trust them
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-claude.url = "github:nixos/nixpkgs/master"; # Dedicated input so claude-code can be updated on its own (master = newest builds)
    nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ { self, nixpkgs, nixos-hardware, home-manager, nixvim, ... }: # Function telling flake which inputs to use
    let
      # Variables Used In Flake
      vars = {
        user = "aske";
        location = "$HOME/.setup";
        terminal = "kitty";
        editor = "nvim";
      };

    in
    {
      nixosConfigurations = import ./hosts {
        inherit inputs nixpkgs home-manager nixvim vars;
      };
    };
}
