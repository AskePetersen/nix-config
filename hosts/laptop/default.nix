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
	# theme = "/home/aske/flake/grub-themes/vimix";
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    discord
    git
    grub2
    libsForQt5.breeze-grub
    wget
    # neovim
  ];
}
