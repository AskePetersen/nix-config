{config, lib, pkgs, hyprland, vars, host, ... }:
with lib;
with host;

{
	programs = {
		steam.enable = false;
		hyprland = {
			enable = true;
			package = hyprland.packages.${pkgs.system}.hyprland;
		};
		# nm-applet = {
		# 	enable = true;
		# 	indicator = true;
		# };
		thunderbird.enable = true;
		starship.enable = true;
		hyprlock.enable = true;
		nixvim.enable = true;
		git.enable = true;
		firefox.enable = true;
	};
}
