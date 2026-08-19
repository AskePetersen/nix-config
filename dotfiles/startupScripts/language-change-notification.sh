#!/usr/bin/env bash
# layout-notify.sh — desktop notification on keyboard layout switch
socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat -U - "UNIX-CONNECT:$socket" | while read -r line; do
	case "$line" in
		activelayout\>\>*)
			layout="${line##*,}"       # e.g. "English (US)" or "Danish"
			notify-send -t 1000 -h string:x-canonical-private-synchronous:kb-layout \
				"⌨ Keyboard" "$layout"
			;;
	esac
done
