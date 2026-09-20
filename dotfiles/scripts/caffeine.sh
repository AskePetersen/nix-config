#!/usr/bin/env bash
# Idle inhibitor. hypridle honours logind's idle inhibitors - its
# general:ignore_systemd_inhibit defaults to false - so holding one pauses
# every listener in hypridle.conf at once: no dim, no lock, no dpms off, no
# suspend. Nothing here touches hypridle.conf, so the normal timeouts come
# straight back the moment the lock is dropped.
#
# Each holder gets its own transient unit, caffeine-<tag>, so the waybar
# toggle and a Claude Code session can hold a lock at the same time without
# releasing each other's. Any one of them being active is enough.
#
# RuntimeMaxSec is the backstop: a holder that dies without cleaning up (kill
# -9, crash, reboot-less resume) still lets the laptop go to sleep eventually
# instead of pinning it awake until you notice a flat battery.
#
#   caffeine.sh                     toggle the manual lock
#   caffeine.sh on|off  [tag]       take/drop a named lock
#   caffeine.sh status              notify + exit 0 if any lock is held
#   caffeine.sh waybar              JSON for the waybar module
#
# Lid close still suspends - this only blocks *idle*, deliberately, so
# shutting the laptop still does the obvious thing. Add :sleep to --what
# below if you want it to keep running with the lid down.

set -u

CMD="${1:-toggle}"
TAG="${2:-manual}"
UNIT="caffeine-${TAG}"
MAX="${CAFFEINE_MAX:-12h}"
WAYBAR_SIGNAL=8

ICON_ON='󰅶'
ICON_OFF='󰛊'

# Any caffeine-* unit counts - a lock held by a Claude session keeps the
# screen up even though the manual toggle is off.
held() {
    [ -n "$(systemctl --user list-units --state=active --plain --no-legend 'caffeine-*' 2>/dev/null)" ]
}

holders() {
    systemctl --user list-units --state=active --plain --no-legend 'caffeine-*' 2>/dev/null \
        | awk '{ sub(/^caffeine-/, "", $1); sub(/\.service$/, "", $1); print $1 }'
}

# The module reads state on an interval too, so a lock taken by a hook shows
# up on its own; this just makes the click feel instant.
refresh_waybar() { pkill -RTMIN+$WAYBAR_SIGNAL waybar 2>/dev/null; }

take() {
    systemctl --user is-active --quiet "$UNIT" && return 0
    # A unit left in `failed` state would block reusing the name.
    systemctl --user reset-failed "$UNIT" 2>/dev/null
    systemd-run --user --quiet --collect \
        --unit="$UNIT" \
        --description="Idle inhibited ($TAG)" \
        --property=RuntimeMaxSec="$MAX" \
        systemd-inhibit --what=idle \
            --who="caffeine" --why="$TAG" \
            sleep infinity
}

drop() {
    systemctl --user stop "$UNIT" 2>/dev/null
    systemctl --user reset-failed "$UNIT" 2>/dev/null
    return 0
}

case "$CMD" in
    on)  take ;;
    off) drop ;;
    toggle)
        if systemctl --user is-active --quiet "$UNIT"; then drop; else take; fi
        if held; then
            notify-send -a caffeine -i preferences-desktop-screensaver \
                "$ICON_ON  Staying awake" "Idle timeouts paused."
        else
            notify-send -a caffeine -i preferences-desktop-screensaver \
                "$ICON_OFF  Back to normal" "Locks at 10 min again."
        fi
        ;;
    status)
        if held; then
            notify-send -a caffeine "$ICON_ON  Staying awake" \
                "Held by: $(holders | paste -sd', ')"
        else
            notify-send -a caffeine "$ICON_OFF  Idle timeouts active" \
                "Dims at 2.5 min, locks at 10, suspends at 15."
        fi
        held
        exit $?
        ;;
    waybar)
        if held; then
            printf '{"text":"%s","class":"active","tooltip":"Staying awake - held by: %s"}\n' \
                "$ICON_ON" "$(holders | paste -sd', ')"
        else
            printf '{"text":"%s","class":"idle","tooltip":"Idle timeouts active - locks at 10 min"}\n' \
                "$ICON_OFF"
        fi
        exit 0
        ;;
    *)
        echo "usage: $(basename "$0") [on|off|toggle|status|waybar] [tag]" >&2
        exit 2
        ;;
esac

refresh_waybar
