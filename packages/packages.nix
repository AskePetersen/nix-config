{ config, lib, system, pkgs, stable, vars, ... }:

{

  environment.systemPackages = with pkgs; [
	catppuccin-cursors.frappeBlue
  	texliveFull
  	bitwarden-desktop
  	zathura # vim pdf-viewer
  	htop
  	blueman # bluetooth
  	thunderbird
  	# bluez
  	# fprintd # fingerscanning
  	pavucontrol # sound control
  	starship # terminal jizz
	brightnessctl
	# grimblast # Screenshot
	# hyprcursor # Cursor
	hypridle
	hyprland
	hyprpaper # Wallpaper
	hyprshot
	kitty
	libnotify
	libreoffice
	nautilus
	nwg-look # change the look of hyprland?
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
