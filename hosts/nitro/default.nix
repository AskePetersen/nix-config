{ config, lib, system, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  services = {
    xserver = {
      enable = true;
    };
  };

  system.stateVersion = "26.05";
}

