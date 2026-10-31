{ config, lib, system, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # GPU: GeForce GTX 1060 6GB (Pascal, GP106). nouveau can't reclock Pascal,
  # so under it the card sits at boot clocks; the proprietary driver is the
  # only way to get real 3D performance. NVIDIA dropped Pascal after the 580
  # branch (nixpkgs' `stable` is 595 and has no Pascal kernel module), so the
  # legacy branch has to be pinned explicitly.
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      open = false; # open kernel modules are Turing and newer only
      modesetting.enable = true; # required for Wayland / Hyprland
      nvidiaSettings = true;
      # Save and restore video memory across suspend via the driver's systemd
      # hooks. Without it the display stays black after resume.
      powerManagement.enable = true;
    };
    graphics.enable32Bit = true; # steam / proton
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  # Hyprland on the proprietary driver: route GL and VA-API through nvidia.
  # WLR_NO_HARDWARE_CURSORS is already set globally in configuration.nix.
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };

  environment.systemPackages = with pkgs; [
    steam
    discord
  ];

  system.stateVersion = "26.11"; # Did you read the comment?
}
