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
    discord
    google-chrome
    claude-code
  ];

  # Memory: 8 GB RAM and zram alone isn't enough headroom for games under
  # Proton, so a disk swapfile backs zram up (zram keeps the higher priority).
  # oomd watches user slices so runaway processes get killed instead of the
  # whole desktop freezing.
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];
  systemd.oomd.enableUserSlices = true;

  # Let zram hold up to all of RAM uncompressed (~2.5-4 GB real when full),
  # and tune the VM for it: swapping to zram is cheaper than dropping page
  # cache, and readahead clustering only helps on disk swap.
  zramSwap.memoryPercent = 100;
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
  };

  # Storage: the original M.2 NVMe drops off the PCIe bus ~40 s after power-on
  # (CSTS=0xffffffff, "Disabling device after reset failure: -19") regardless
  # of load or temperature, so the OS lives on a 2.5" SATA SSD instead. The
  # NVMe can stay plugged in: the kernel gives up on it at boot and nothing
  # here references it.

  system.stateVersion = "26.11"; # Did you read the comment?
}
