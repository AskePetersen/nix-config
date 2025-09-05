{ config, lib, system, pkgs, stable, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  # Bootloader.
  boot = {
    # kernel.sysrq = 1;
    # extraModulePackages = [ config.boot.kernelPackages.evdi ];
    # kernelModules = [ "evdi" ];
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
  # systemd.watchdog = {
  #   rebootTime = "60s";
  #   runtimeTime = "60s";
  # };

	systemd.settings.Manager = {
		RebootWatchdogSec = "60";
		RuntimeWatchdogSec = "60";
	};

    # watchdogd = {
    #   enable = true;
    #   runtimeTime = "60s";
    #   rebootTime = 10;
    # };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
