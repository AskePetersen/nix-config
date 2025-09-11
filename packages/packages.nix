{ config, lib, system, pkgs, stable, vars, ... }:


{
	virtualisation.docker.enable = true;
	environment.systemPackages = with pkgs; [
		sshfs # Litteraly best tool ever for remote editing
		mesa # used for some hyprland conf
		libdrm # used for some hyprland conf
		google-chrome
		dbeaver-bin
		glow # Used for reading markdown files
		slack
		mysql84 # used for dbeaver 
		pylint
		# tmux
		nixpkgs-fmt
		black
		isort
		eslint
		qalculate-qt
		nest-cli
		nodejs_20
		nodePackages.localtunnel
		nodePackages.prettier
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
		# hyprland
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
		# xdg-desktop-portal-hyprland
		xwayland # X session
		hyprlock
		discord
		git
		grub2
		# libsForQt5.breeze-grub
		wget
	];
}
