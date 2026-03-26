#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/nix-config/dotfiles/hypr/wallpapers"
mkdir -p "$WALLPAPER_DIR"

while true; do
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | shuf -n 1)

    if [ -z "$WALLPAPER" ]; then
        WALLPAPER="$HOME/nix-config/dotfiles/hypr/background.png"
    fi

    hyprctl hyprpaper preload "$WALLPAPER"
    hyprctl hyprpaper wallpaper ",$WALLPAPER"
    hyprctl hyprpaper unload all

    sleep 1800 # 30 minutes
done
