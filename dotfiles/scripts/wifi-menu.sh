#!/usr/bin/env bash
# wofi-driven wifi picker. Uses the same wofi config as $menu, so it inherits
# dotfiles/wofi/style.css and matches the launcher instead of looking like
# nm-applet's stock GTK menu.

# Nerd Font glyphs - same font the bar and wofi already use
ICON_4='󰤨'; ICON_3='󰤥'; ICON_2='󰤢'; ICON_1='󰤟'; ICON_0='󰤯'
ICON_LOCK='󰌾'; ICON_OFF='󰖪'; ICON_SCAN='󰑓'; ICON_ON='󰄬'

notify() { notify-send -t 3000 "Wi-Fi" "$1"; }
menu()   { wofi --dmenu --insensitive --width 500 --lines 12 --prompt "$1"; }

# nmcli terse output backslash-escapes ':' and '\' inside SSIDs
unescape() { printf '%s' "$1" | sed 's/\\\(.\)/\1/g'; }

# Same 20% steps as waybar's network.format-icons. Indexed rather than an
# if-chain so the loop below doesn't fork a subshell per network; the 6th slot
# catches signal == 100.
BARS=("$ICON_0" "$ICON_1" "$ICON_2" "$ICON_3" "$ICON_4" "$ICON_4")

wifi_dev=$(nmcli -t -f DEVICE,TYPE device | awk -F: '$2=="wifi"{print $1; exit}')
[ -z "$wifi_dev" ] && { notify "No wifi device found"; exit 1; }

# --rescan yes on the first run costs a second but avoids showing a stale list
rescan=${1:-auto}

declare -A SSID_OF SEC_OF seen
entries=()

# Sort connected-first, then by signal descending. IN-USE is '*' or empty, so
# a reverse sort on it floats the active network to the top.
while IFS=: read -r inuse signal security ssid; do
    ssid=$(unescape "$ssid")
    [ -z "$ssid" ] && continue
    # One row per BSSID: keep only the strongest row for each SSID
    [ -n "${seen[$ssid]}" ] && continue
    seen[$ssid]=1

    lock=" "; [ -n "$security" ] && lock="$ICON_LOCK"
    mark="";  [ "$inuse" = "*" ] && mark="  $ICON_ON"

    printf -v line '%s  %-22s %s  %3d%%%s' \
        "${BARS[signal / 20]}" "$ssid" "$lock" "$signal" "$mark"
    entries+=("$line")
    SSID_OF["$line"]="$ssid"
    SEC_OF["$line"]="$security"
done < <(nmcli -t -f IN-USE,SIGNAL,SECURITY,SSID device wifi list --rescan "$rescan" \
         | sort -t: -k1,1r -k2,2nr)

entries+=("$ICON_OFF  Disconnect" "$ICON_SCAN  Rescan")

choice=$(printf '%s\n' "${entries[@]}" | menu "Wi-Fi")
[ -z "$choice" ] && exit 0

case "$choice" in
    "$ICON_OFF  Disconnect")
        nmcli device disconnect "$wifi_dev" >/dev/null && notify "Disconnected"
        exit 0 ;;
    "$ICON_SCAN  Rescan")
        exec "$0" yes ;;
esac

ssid="${SSID_OF[$choice]}"
[ -z "$ssid" ] && exit 0

# A saved profile connects without asking. If there isn't one (or the stored
# password is wrong) this fails and we fall through to the prompt.
if nmcli connection up id "$ssid" >/dev/null 2>&1; then
    notify "Connected to $ssid"
    exit 0
fi

if [ -n "${SEC_OF[$choice]}" ]; then
    pw=$(wofi --dmenu --password --width 500 --lines 1 --prompt "Password for $ssid")
    [ -z "$pw" ] && exit 0
    out=$(nmcli device wifi connect "$ssid" password "$pw" 2>&1); rc=$?
else
    out=$(nmcli device wifi connect "$ssid" 2>&1); rc=$?
fi

if [ "$rc" -eq 0 ]; then
    notify "Connected to $ssid"
else
    notify-send -u critical -t 5000 "Wi-Fi" "Could not connect to $ssid: $out"
fi
