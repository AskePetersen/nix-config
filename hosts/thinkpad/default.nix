{ config, lib, system, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Hibernation: the kernel needs to know which swap holds the image on resume.
  # Without this, hibernating writes the image but boots cold and loses the session.
  boot.resumeDevice = "/dev/disk/by-uuid/9040d67e-bfdb-43f4-ac81-88a58b182cfe"; # nvme0n1p3, 8.8G swap

  # Android development lives on this machine only
  environment.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk17}/lib/openjdk"; # for running android studio
    CAPACITOR_ANDROID_STUDIO_PATH = "/run/current-system/sw/bin/android-studio";
  };

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
    python313
    nixpkgs-fmt
    black
    isort
    eslint
    nest-cli
    nodejs_22
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
