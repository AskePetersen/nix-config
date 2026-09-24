{ config, lib, system, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # This NVMe drops off the PCIe bus coming out of deep APST sleep
  # ("nvme 0000:06:00.0: Unable to change power state from D3cold to D0"),
  # which corrupts whatever is mid-write. Don't let it sleep that deeply.
  # SMART is clean (0 media errors, 0 critical warnings), so this is a
  # power-state quirk, not a failing drive.
  boot.kernelParams = [ "nvme_core.default_ps_max_latency_us=0" ];

  services = {
    xserver = {
      enable = true;
    };
  };

  system.stateVersion = "26.11"; # Did you read the comment?
}

