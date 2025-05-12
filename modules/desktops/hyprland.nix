{config, lib, pkgs, hyprland, vars, host, ... }:
with lib;
with host;
{
  options = {
    hyprland.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
