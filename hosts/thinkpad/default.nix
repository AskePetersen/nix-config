{ config, lib, system, pkgs, stable, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" ];
    };
  };

	environment.systemPackages = with pkgs; [
		dbeaver-bin
		glow # Used for reading markdown files
		mysql84 # used for dbeaver 
		pylint
		nixpkgs-fmt
		black
		isort
		eslint
		nest-cli
		nodejs_20
		nodePackages.prettier
		nodePackages.typescript
		nodePackages.typescript-language-server
	];
  # hyprland.enable = true;
}
