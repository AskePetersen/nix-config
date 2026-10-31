# Settings shared by the laptops (thinkpad, ideapad) that mean nothing on a
# desktop: battery handling, idle hibernation, fingerprint reader, and the
# hardware clock kept in local time for the Windows dual-boot.
{ lib, pkgs, ... }:

{
  services = {
    fprintd.enable = true;
    # Low-battery protection: without upower nothing acts on battery level, so
    # the laptop runs until the hardware cutoff and fully drains the battery.
    # PowerOff is the safe default; hosts with working resume override it to
    # Hibernate (see hosts/thinkpad/default.nix).
    upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 7;
      percentageAction = 5;
      criticalPowerAction = lib.mkDefault "PowerOff";
    };
  };

  systemd = {
    # `systemctl suspend-then-hibernate` sleeps to RAM first (instant resume) and
    # falls through to hibernate after this long, so an idle laptop stops draining.
    # hypridle suspends at 15min idle, so 10min here puts hibernate at 25min idle.
    sleep.settings.Sleep.HibernateDelaySec = "10min";

    settings.Manager = {
      RebootWatchdogSec = "60";
      RuntimeWatchdogSec = "60";
      WatchdogDevice = "/dev/watchdog1";
    };

    # Battery conservation: cap charging at 80% on every boot, and make the
    # sysfs node wheel-writable so charge_control.sh can toggle 80/100 without
    # sudo. Toggling to 100% lasts until the next reboot, then it's back to 80.
    services.battery-charge-threshold = {
      description = "Cap battery charging at 80%";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "battery-charge-threshold" ''
          f=/sys/class/power_supply/BAT0/charge_control_end_threshold
          if [ -f "$f" ]; then
            echo 80 > "$f"
            chgrp wheel "$f"
            chmod 664 "$f"
          fi
        '';
      };
    };
  };

  time.hardwareClockInLocalTime = true;
}
