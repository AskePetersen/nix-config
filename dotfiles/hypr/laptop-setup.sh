#!/usr/bin/env bash
# Laptop only
# Enable the laptop panel, then disable every other output.
# Never disable the last enabled monitor: Hyprland 0.55.3 segfaults in the
# headless-fallback path of enterUnsafeState() when no outputs remain.

internal=eDP-1

enabled() { hyprctl monitors -j | jq -e --arg m "$1" 'any(.[]; .name == $m)' >/dev/null; }

hyprctl keyword monitor "$internal,3840x2160@60,0x0,2"

for _ in $(seq 20); do
    enabled "$internal" && break
    sleep 0.1
done

if ! enabled "$internal"; then
    notify-send -u critical "Monitors" "$internal did not come up - monitors unchanged"
    exit 1
fi

hyprctl monitors all -j | jq -r --arg m "$internal" '.[] | select(.name != $m) | .name' |
    while read -r mon; do
        hyprctl keyword monitor "$mon,disable"
    done

notify-send "Monitors" "Laptop only"
