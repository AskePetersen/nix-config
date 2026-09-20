#!/usr/bin/env bash
# Apply the right Hyprland monitor layout.
#
#   monitor-setup.sh          auto-detect from what is connected
#   monitor-setup.sh laptop   force laptop panel only, disable everything else
#
# Bound to SUPER+SHIFT+M / SUPER+SHIFT+T and run once at Hyprland startup.

internal=eDP-1
internal_mode="3840x2160@60,0x0,2"

enabled() { hyprctl monitors -j | jq -e --arg m "$1" 'any(.[]; .name == $m)' >/dev/null; }

# Disable $1 only once $2 is actually enabled - dropping the last enabled
# monitor segfaults Hyprland 0.55.3 (enterUnsafeState headless fallback).
disable_after() {
    local ok=""
    for ((i = 0; i < 20; i++)); do
        if enabled "$2"; then ok=1; break; fi
        sleep 0.1
    done
    if [ -n "$ok" ]; then
        hyprctl keyword monitor "$1,disable"
    else
        notify-send -u critical "Monitors" "$2 did not come up - keeping $1 on"
    fi
}

# Laptop panel on, every other output off.
laptop_only() {
    hyprctl keyword monitor "$internal,$internal_mode"
    while read -r mon; do
        disable_after "$mon" "$internal"
    done < <(hyprctl monitors all -j | jq -r --arg m "$internal" '.[] | select(.name != $m) | .name')
    notify-send "Monitors" "Laptop only"
}

if [ "${1:-auto}" = "laptop" ]; then
    laptop_only
    exit 0
fi

connected=$(hyprctl monitors all -j | jq -r '.[].name')

# $connected is already in memory - match on it with a case instead of
# spawning echo|grep per branch.
case $'\n'"$connected"$'\n' in
    *$'\n'DP-1$'\n'*)
        # Work: ultrawide only, laptop panel off
        hyprctl keyword monitor "DP-1,3440x1440@60,0x0,1"
        disable_after "$internal" DP-1
        notify-send "Monitors" "Work ultrawide"
        ;;
    *$'\n'DVI-I-1$'\n'*)
        # Home: Samsung + laptop
        hyprctl keyword monitor "$internal,$internal_mode"
        hyprctl keyword monitor "DVI-I-1,1920x1080@60,auto-left,1"
        notify-send "Monitors" "Home dual"
        ;;
    *)
        laptop_only
        ;;
esac
