#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/nix-config/dotfiles/hypr/wallpapers"
mkdir -p "$WALLPAPER_DIR"

# Only images that cover every connected monitor without upscaling
# (hyprpaper fit_mode = cover). Images in wallpapers/lowres/ are never picked.
# Without imagemagick's identify, skip the size check.
sharp_enough() {
    command -v identify >/dev/null || return 0
    local w h
    read -r w h < <(identify -ping -format "%w %h\n" "$1" 2>/dev/null) || return 1
    [ "$w" -ge "$max_w" ] && [ "$h" -ge "$max_h" ]
}

# Hyprland starts this before hyprpaper; wait for it to come up.
until pgrep -x hyprpaper >/dev/null; do sleep 0.5; done

while true; do
    read -r max_w max_h < <(hyprctl monitors -j | jq -r '[max_by(.width).width, max_by(.height).height] | @tsv')

    WALLPAPER=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | shuf |
        while read -r f; do sharp_enough "$f" && { echo "$f"; break; }; done)

    if [ -z "$WALLPAPER" ]; then
        WALLPAPER="$WALLPAPER_DIR/background.png"
    fi

    # hyprpaper 0.8 dropped preload/unload; wallpaper loads the image itself.
    # Retry briefly in case hyprpaper's socket isn't ready yet.
    for _ in $(seq 20); do
        out=$(hyprctl hyprpaper wallpaper ",$WALLPAPER" 2>&1) && ! grep -qi error <<<"$out" && break
        sleep 0.5
    done

    sleep 1800 # 30 minutes
done
