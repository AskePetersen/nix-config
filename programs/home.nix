{ config, lib, system, pkgs, stable, vars, ... }:

{
	home-manager.users.${vars.user} = {
		# kitty
		home.file.".config/kitty/kitty.conf".source = ../dotfiles/kitty/kitty.conf;
		home.file.".config/kitty/current-theme.conf".source = ../dotfiles/kitty/current-theme.conf;

		# waybar
		home.file.".config/waybar/config.jsonc".source = ../dotfiles/waybar/config.jsonc;
		home.file.".config/waybar/mocha.css".source = ../dotfiles/waybar/mocha.css;
		home.file.".config/waybar/style.css".source = ../dotfiles/waybar/style.css;

		# hypr
		home.file.".config/hypr/hypridle.conf".source = ../dotfiles/hypr/hypridle.conf;
		home.file.".config/hypr/hyprland.conf".source = ../dotfiles/hypr/hyprland.conf;
		home.file.".config/hypr/hyprlock.conf".source = ../dotfiles/hypr/hyprlock.conf;
		home.file.".config/hypr/hyprpaper.conf".source = ../dotfiles/hypr/hyprpaper.conf;
		home.file.".config/hypr/mocha.conf".source = ../dotfiles/hypr/mocha.conf;

		# wofi
		home.file.".config/wofi/style.css".source = ../dotfiles/wofi/style.css;
	};
}
