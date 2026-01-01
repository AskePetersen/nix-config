#!/usr/bin/env bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/nix-config/dotfiles/hypr/wallpapers"

# Create wallpapers directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Get a random wallpaper from the directory
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | shuf -n 1)

# Fallback to default if no wallpapers found
if [ -z "$WALLPAPER" ]; then
    WALLPAPER="$HOME/nix-config/dotfiles/hypr/background.png"
fi

# Update hyprpaper config
cat > "$HOME/nix-config/dotfiles/hypr/hyprpaper.conf" << EOF
preload = $WALLPAPER
wallpaper = , $WALLPAPER
EOF

# Reload hyprpaper if it's running
if pidof hyprpaper > /dev/null; then
    pkill -SIGUSR2 hyprpaper
fi