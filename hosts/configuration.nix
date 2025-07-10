{ config, lib, pkgs, stable, inputs, vars, ... }:

{
  imports = (
    import ../programs ++
	import ../packages
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

  hardware = {
	  bluetooth = {
		  enable = true;
		  powerOnBoot = false;
	  };
  };

  time = {
    timeZone = "Europe/Copenhagen";
    hardwareClockInLocalTime = true;
  };

  # Select internationalisation properties.
  i18n = { 
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "da_DK.UTF-8";
      LC_IDENTIFICATION = "da_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8";
      LC_MONETARY = "da_DK.UTF-8";
      LC_NAME = "da_DK.UTF-8";
      LC_NUMERIC = "da_DK.UTF-8";
      LC_PAPER = "da_DK.UTF-8";
      LC_TELEPHONE = "da_DK.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  # Enable the X11 windowing system.
  services = {
	gvfs.enable = true;
	udisks2.enable = true; # used for USB devices
	blueman.enable = true;
	fprintd.enable = true;	
    pulseaudio.enable = false;
    printing.enable = true;
	# onedrive = {
	# 	enable = true; # Set this to false and uncomment when we want to enable it (maybe)
	# 	monitor = true;
	# };
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      # desktopManager.gnome.enable = true;
      # xkb = {
      #   layout = "dk";
      #   variant = "nodeadkeys";
      # };
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "dk-latin1";
  };

  # Enable sound with pipewire.
  security = {
	  rtkit.enable = true;
	  polkit.enable = true;
  };
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
    extraGroups = [ "plugdev" "networkmanager" "wheel" ];
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

  fonts.packages = with pkgs; [
  	pkgs.nerd-fonts.caskaydia-cove
    # font-awesome # Icons
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
