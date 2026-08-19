#!/usr/bin/env bash
# Auto-detect connected monitors and apply the right Hyprland config

connected=$(hyprctl monitors all -j | jq -r '.[].name')

enabled() { hyprctl monitors -j | jq -e --arg m "$1" 'any(.[]; .name == $m)' >/dev/null; }

# Disable $1 only once $2 is actually enabled - dropping the last enabled
# monitor segfaults Hyprland 0.55.3 (enterUnsafeState headless fallback).
disable_after() {
    for _ in $(seq 20); do
        enabled "$2" && break
        sleep 0.1
    done
    if enabled "$2"; then
        hyprctl keyword monitor "$1,disable"
    else
        notify-send -u critical "Monitors" "$2 did not come up - keeping $1 on"
    fi
}

if echo "$connected" | grep -q "^DP-1$"; then
    # Work: ultrawide only, laptop panel off
    hyprctl keyword monitor "DP-1,3440x1440@60,0x0,1"
    disable_after eDP-1 DP-1
    notify-send "Monitors" "Work ultrawide"
elif echo "$connected" | grep -q "^DVI-I-1$"; then
    # Home: Samsung + laptop
    hyprctl keyword monitor "eDP-1,3840x2160@60,0x0,2"
    hyprctl keyword monitor "DVI-I-1,1920x1080@60,auto-left,1"
    notify-send "Monitors" "Home dual"
else
    # Laptop only
    hyprctl keyword monitor "eDP-1,3840x2160@60,0x0,2"
    notify-send "Monitors" "Laptop only"
fi
