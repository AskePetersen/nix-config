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
}

