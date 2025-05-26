{ config, lib, pkgs, stable, inputs, vars, ... }:

{
	programs = {
		hyprland = {
			enable = true;
			package = hyprland.packages.${pkgs.system}.hyprland;
		};
		nm-applet = {
			enable = true;
			indicator = true;
		};
		hyprlock.enable = true;
		nixvim.enable = true;
		git.enable = true;
		firefox.enable = true;
	};
}
