#!/usr/bin/env bash
# Listen for Hyprland monitor hotplug events and re-apply the monitor profile.
# Keeps a blocked socat reader on the event socket (near-zero idle cost);
# on plug/unplug it re-runs monitor-setup.sh so the correct outputs come back.

socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat -U - "UNIX-CONNECT:$socket" | while read -r line; do
    case "$line" in
        monitoradded*|monitorremoved*)
            ~/nix-config/dotfiles/startupScripts/monitor-setup.sh
            ;;
    esac
done
