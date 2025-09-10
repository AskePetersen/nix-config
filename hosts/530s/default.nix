{ config, lib, system, pkgs, stable, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  # Bootloader.
  boot = {
    loader =  {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
      enable = true;
      devices = [ "nodev" ];
      configurationLimit = 10;
      useOSProber = true;
      gfxmodeEfi = "1920x1080";
      };
    };
  };

	systemd.settings.Manager = {
		RebootWatchdogSec = "60";
		RuntimeWatchdogSec = "60";
	};

  # hyprland.enable = true;
  environment.sessionVariables = {
	XDG_PICTURES_DIR = "$HOME";
	EDITOR = "nvim";
	VISUAL = "nvim";
	# Wayland / Hyprland specific variables
	NIXOS_OZONE_WL = "1";
	WLR_NO_HARDWARE_CURSORS = "1";
  };
}
