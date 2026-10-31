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
    };
    graphics.enable32Bit = true; # steam / proton
  };

  services.xserver = {
    enable = true;
    # configuration.nix lists displaylink+modesetting for the laptops' dock.
    # There is no dock here, and nvidia has to be the only driver named or
    # the X server / Hyprland will pick the wrong one.
    videoDrivers = lib.mkForce [ "nvidia" ];
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

  # Storage: the original M.2 NVMe drops off the PCIe bus ~40 s after power-on
  # (CSTS=0xffffffff, "Disabling device after reset failure: -19") regardless
  # of load or temperature, so the OS lives on a 2.5" SATA SSD instead. The
  # NVMe can stay plugged in: the kernel gives up on it at boot and nothing
  # here references it.

  system.stateVersion = "26.11"; # Did you read the comment?
}
