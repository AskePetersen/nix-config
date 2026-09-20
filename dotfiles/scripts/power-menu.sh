#!/usr/bin/env bash
# wofi power menu. Plain `wofi --dmenu`, so it inherits dotfiles/wofi/style.css
# and matches the launcher and wifi-menu.sh.
#
# Suspend does not lock first on purpose: hypridle's before_sleep_cmd already
# runs `loginctl lock-session`, so locking here would just race it.

ICON_LOCK='󰌾'
ICON_SLEEP='󰒲'
ICON_LOGOUT='󰍃'
ICON_REBOOT='󰜉'
ICON_OFF='󰐥'
ICON_NO='󰅖'
ICON_YES='󰄬'

menu() {
    wofi --dmenu --insensitive --width 320 --lines "$2" --prompt "$1"
}

# Anything that throws away running work asks first. Lock and suspend don't -
# they're reversible and asking would just be friction on a key you hit often.
confirm() {
    local answer
    answer=$(printf '%s\n' "$ICON_NO  Cancel" "$ICON_YES  $1" | menu "$1?" 2)
    # Compare with the glyph prefix stripped, same as the main case below, so
    # the icon only has to be spelled once.
    [ "${answer#*  }" = "$1" ]
}

choice=$(printf '%s\n' \
    "$ICON_LOCK  Lock" \
    "$ICON_SLEEP  Suspend" \
    "$ICON_LOGOUT  Log out" \
    "$ICON_REBOOT  Reboot" \
    "$ICON_OFF  Shut down" \
    | menu "Power" 5)

[ -z "$choice" ] && exit 0

# Drop the "icon  " prefix so the cases don't have to repeat the glyphs.
case "${choice#*  }" in
    "Lock")      exec hyprlock ;;
    "Suspend")   exec systemctl suspend ;;
    "Log out")   confirm "Log out"   && exec hyprctl dispatch exit ;;
    "Reboot")    confirm "Reboot"    && exec systemctl reboot ;;
    "Shut down") confirm "Shut down" && exec systemctl poweroff ;;
esac
