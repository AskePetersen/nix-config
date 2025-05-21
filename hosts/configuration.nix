{ config, lib, pkgs, stable, inputs, vars, ... }:

{
  imports = (
    # import ../modules/desktops ++ # enable when we want hyprland
    import ../modules/editors ++
    # import ../modules/hardware ++
    # import ../modules/programs ++
    # import ../modules/services ++
    # import ../modules/theming ++
    import ../modules/shell
  );

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.package = pkgs.nix;

  
  security.sudo.wheelNeedsPassword = false; # Bad practice, I'm just tired of typing root pwd

  networking = {
    hostName = "aske";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    networkmanager = {
      enable = true;
    };
  };

  time = {
    timeZone = "Europe/Copenhagen";
    hardwareClockInLocalTime = true;
  };

  # Select internationalisation properties.
  i18n = { 
    defaultLocale = "en_DK.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "da_DK.UTF-8";
      LC_IDENTIFICATION = "da_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8";
      LC_MONETARY = "da_DK.UTF-8";
      LC_NAME = "da_DK.UTF-8";
      LC_NUMERIC = "da_DK.UTF-8";
      LC_PAPER = "da_DK.UTF-8";
      LC_TELEPHONE = "da_DK.UTF-8";
      LC_TIME = "da_DK.UTF-8";
    };
  };

  # Enable the X11 windowing system.
  services = {
	onedrive.enable = true;
    pulseaudio.enable = false;
    printing.enable = true;
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      # desktopManager.gnome.enable = true;
      xkb = {
        layout = "dk";
        variant = "nodeadkeys";
      };
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "dk-latin1";
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.aske = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [
    #  thunderbird
    # ];
  };

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = "24.11";
    };
    programs = {
      home-manager.enable = true;
    };
  };

  # Install firefox.
  programs = {
	nm-applet = {
		enable = true;
		indicator = true;
	};
    firefox.enable = true;
    nixvim.enable = true;
	hyprland = {
		enable = true;
	};
  };

  fonts.packages = with pkgs; [
    font-awesome # Icons
  ];

  environment.systemPackages = with pkgs; [
	hyprpaper
	hypridle
  	hyprlock
	libnotify
	swaynotificationcenter
	hyprshot
	nautilus
	brightnessctl
	libreoffice
	hyprland
	waybar
	wofi
	kitty
	xdg-desktop-portal-hyprland
# 	network-manager-applet
  ];


  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.shellAliases = { vim = "nvim"; };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 40d";
    };
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
