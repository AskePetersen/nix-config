{ config, lib, system, pkgs, stable, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # hardware.graphics = {
  #   extraPackages = with pkgs; [
  #     intel-media-driver
  #   ];
  # };
  #

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" ];
    };
  };

  environment.systemPackages = with pkgs; [
    claude-code
    openssl
    postman
    sshfs # Litteraly best tool ever for remote editing
    google-chrome
    dbeaver-bin
    glow # Used for reading markdown files
    mysql84 # used for dbeaver 
    pylint
    nixpkgs-fmt
    black
    isort
    eslint
    nest-cli
    nodejs_20
    localtunnel
    intelephense
    prettier
    typescript
    typescript-language-server
    #GAMING
    steam
    discord
    # lutris
    # protonplus
    # protonup-rs
    android-studio
    jdk17
  ];
  # hyprland.enable = true;
}
