{ config, lib, system, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  # Bootloader.

  # Hibernation: swap here is a file, so resume needs both the filesystem it
  # lives on and its physical offset. Get the offset by running, on this host:
  #   sudo filefrag -v /var/lib/swapfile | awk 'NR==4 {gsub("\\.\\.","",$4); print $4}'
  # then uncomment both lines below with that number.
  # boot.resumeDevice = "/dev/disk/by-uuid/aab03e27-7934-4e01-b02d-daffc1a58b22"; # root fs
  # boot.kernelParams = [ "resume_offset=REPLACE_ME" ];
  # Note: 8G swapfile is only worth hibernating into if RAM in use stays below it.

  hardware = {
    graphics = {
      enable32Bit = true; # used for pokemon
    };
  };
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
  };

  environment.systemPackages = with pkgs; [
    melonDS
    lutris
    wine
  ];
  system.stateVersion = "24.11"; # Did you read the comment?
}
