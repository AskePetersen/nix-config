#!/usr/bin/env bash
# Auto-detect connected monitors and apply the right Hyprland config

connected=$(hyprctl monitors all -j | jq -r '.[].name')

if echo "$connected" | grep -q "^DP-1$"; then
    # Work: ultrawide + laptop at minimal res to keep keybinds working
    hyprctl keyword monitor "DP-1,3440x1440@60,0x0,1"
    hyprctl keyword monitor "eDP-1,disabled"
    notify-send "Monitors" "Work ultrawide"
elif echo "$connected" | grep -q "^DVI-I-1$"; then
    # Home: Samsung + laptop
    hyprctl keyword monitor "DVI-I-1,1920x1080@60,0x0,1"
    hyprctl keyword monitor "eDP-1,3840x2160@60,1920x0,2"
    notify-send "Monitors" "Home dual"
else
    # Laptop only
    hyprctl keyword monitor "eDP-1,3840x2160@60,0x0,2"
    notify-send "Monitors" "Laptop only"
fi
