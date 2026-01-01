
BAT="/sys/class/power_supply/BAT0"
CURRENT=$(cat $BAT/charge_control_end_threshold)

if [ "$CURRENT" -eq 100 ]; then
	~/nix-config/dotfiles/scripts/charge_control.sh
fi
