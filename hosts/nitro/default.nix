{ config, lib, system, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # This NVMe drops off the PCIe bus and never comes back:
  # "nvme 0000:06:00.0: Unable to change power state from D3cold to D0",
  # followed by I/O errors and ext4 remounting read-only mid-write.
  # SMART is clean (0 media errors, 0 critical warnings) and Windows was
  # stable on the same drive, so this is power management, not dying flash.
  # D3cold is a PCIe device state, so the port ones do the real work here;
  # the nvme_core one disables the drive's internal APST on top of that.
  boot.kernelParams = [
    "pcie_port_pm=off"
    "pcie_aspm=off"
    "nvme_core.default_ps_max_latency_us=0"
  ];

  services = {
    xserver = {
      enable = true;
    };
  };

  system.stateVersion = "26.11"; # Did you read the comment?
}

