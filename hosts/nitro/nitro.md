# nitro: Acer Nitro N50-600 desktop

What an agent needs to know before touching this host. Read `default.nix` for
the config itself; this file holds the reasons and the gotchas the config
can't tell you.

## Hardware

- Ryzen 5 2500X (4 cores / 8 threads), Tjmax 95 °C. Stock AMD Wraith cooler.
  Measured ~71 °C Tctl under 8-thread `stress-ng`, so thermals are fine.
- 8 GB DDR4 in 2 of 4 slots. Two slots free
- GeForce GTX 1060 6GB (Pascal, GP106). No iGPU
- LiteOn PS-7501-5 500 W PSU, non-modular.
- Intel wifi (`iwlwifi`). Ethernet port on the board.
- UEFI boot. GRUB EFI from the shared config.

- The OS lives on a 2.5" SATA SSD, `/dev/sda`
- Installed with the graphical installer, "erase disk", swap partition
  without hibernate. `hardware-configuration.nix` is the installer's.
  Hibernate is pointless on a mains desktop; don't add `boot.resumeDevice`.

## GPU: the driver must stay on `legacy_580`

NVIDIA dropped Pascal after the 580 branch. nixpkgs' `stable` is 595+ and
has no kernel module for this card. `hardware.nvidia.package` is pinned to
`nvidiaPackages.legacy_580` for that reason. Do not bump it to `stable`,
`latest` or `production`, and do not set `open = true` (open modules are
Turing and newer). nouveau can't reclock Pascal, so it's not a fallback
either; the card idles at boot clocks under it.

`videoDrivers` is `[ "nvidia" ]` only. DisplayLink belongs to the laptops.

