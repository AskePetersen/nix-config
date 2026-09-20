#!/usr/bin/env bash
# Toggle the battery charge limit between 80% and 100%, or report the current
# one without changing it:
#
#   charge_control.sh          toggle, then show the new limit
#   charge_control.sh status   show the current limit, change nothing
#
# No sudo needed: the battery-charge-threshold systemd service
# (hosts/configuration.nix) makes the sysfs node wheel-writable at boot.
# Reverts to 80% on reboot.
BAT="/sys/class/power_supply/BAT0/charge_control_end_threshold"

fail() {
    echo "$1" >&2
    notify-send -u critical -t 5000 "Battery" "$1"
    exit 1
}

# Replace the previous popup rather than stacking a new one on every click.
notify() {
    echo "$2"
    notify-send -t 3000 \
        -h "string:x-canonical-private-synchronous:charge-limit" \
        "$1" "$2"
}

# Same wording whether we just set the limit or are only reporting it, so the
# popup reads the same either way.
describe() {
    if [ "$1" -eq 80 ]; then
        echo "󰁿  Conservation - stops charging at 80%"
    else
        echo "󰂄  Full charge - stops charging at $1%"
    fi
}

[ -f "$BAT" ] || fail "No charge threshold control on this machine ($BAT missing)"

current=$(cat "$BAT")

if [ "${1:-toggle}" = "status" ]; then
    notify "Charge limit" "$(describe "$current")"
    exit 0
fi

[ -w "$BAT" ] || fail "$BAT is not writable - did battery-charge-threshold.service run?"

if [ "$current" -eq 80 ]; then new=100; else new=80; fi

echo "$new" > "$BAT" || fail "Failed to write to $BAT"
notify "Charge limit set" "$(describe "$new")"
