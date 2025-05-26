{ config, lib, system, pkgs, stable, vars, ... }:

{

  environment.systemPackages = with pkgs; [
  	starship
	brightnessctl
	grimblast # Screenshot
	hyprcursor # Cursor
	hypridle
	hyprland
	hyprpaper # Wallpaper
	hyprshot
	kitty
	libnotify
	libreoffice
	nautilus
	nwg-look
	swaynotificationcenter
	waybar
	wl-clipboard # Clipboard
	wlr-randr # Monitor Settings
	wofi
	xdg-desktop-portal-hyprland
	xwayland # X session
  	hyprlock
    discord
    git
    grub2
    libsForQt5.breeze-grub
    wget
  ];
}
