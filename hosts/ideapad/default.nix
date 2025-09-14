{ config, lib, system, pkgs, stable, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  # Bootloader.

  hardware = {
	  graphics = {
			enable32Bit = true; # used for pokemon
	  };
  };
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
  };

	environment.systemPackages = with pkgs; [
	  melonDS
	];
}
