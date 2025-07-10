{ config, lib, system, pkgs, stable, vars, ... }:


{
	environment.systemPackages = with pkgs; [
  	
		tmux
		nixpkgs-fmt
		prettierd
		black
		isort
		eslint_d
		qalculate-qt
		nodejs_24
		nodePackages.typescript
		nodePackages.typescript-language-server
# python313
# python313Packages.pypdf
		feh # Image viewer
		file # Just the findcommand
		catppuccin-cursors.frappeBlue # my neat cursor
		texliveFull # Den har alt latex
		bitwarden-desktop # password manager. kæmpe bis
		zathura # vim pdf-viewer
		htop # se kørende processor
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
		gvfs # USB drives
		gnome-disk-utility 	# USB drives
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
