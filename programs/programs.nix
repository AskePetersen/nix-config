{ config, lib, pkgs, vars, host, ... }:
with lib;
with host;

{
  programs = {
    dconf.enable = true; # gsettings backend, needed for GTK theming
    steam.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
      # package = hyprland.packages.${pkgs.system}.hyprland;
    };
    thunderbird.enable = true;
    starship.enable = true;
    hyprlock.enable = true;
    nixvim.enable = true;
    firefox.enable = true;
  };
  zramSwap.enable = true;
}
