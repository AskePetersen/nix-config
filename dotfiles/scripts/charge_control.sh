BAT="/sys/class/power_supply/BAT0"
CURRENT=$(cat $BAT/charge_control_end_threshold)

if [ "$CURRENT" -eq 80 ]; then
    echo 100 | sudo tee $BAT/charge_control_end_threshold
    echo "Battery will now charge to 100%"
else
    echo 80 | sudo tee $BAT/charge_control_end_threshold
    echo "Battery conservation enabled (max 80%)"
fi
