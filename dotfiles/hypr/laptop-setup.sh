#!/usr/bin/env bash
# Laptop only
# Disable all monitors except the laptop
for mon in $(hyprctl monitors all -j | jq -r '.[].name'); do
    [ "$mon" != "eDP-1" ] && hyprctl keyword monitor "$mon,disable"
done
hyprctl keyword monitor "eDP-1,3840x2160@60,0x0,2"
notify-send "Monitors" "Laptop only"
