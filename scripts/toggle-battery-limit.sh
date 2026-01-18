#!/bin/bash
# Toggles between 65% and 100% charging threshold

THRESHOLD_FILE="/sys/class/power_supply/BAT0/charge_control_end_threshold"
STATE_FILE="/var/tmp/battery_limit_state"

# Check if threshold file exists
if [ ! -f "$THRESHOLD_FILE" ]; then
  notify-send "Battery Limit" "Threshold file not found. Check your battery path." -u critical
  exit 1
fi

# Read current state (default to 100 if file doesn't exist)
if [ -f "$STATE_FILE" ]; then
  CURRENT=$(cat "$STATE_FILE")
else
  CURRENT=100
fi

# Toggle the limit
if [ "$CURRENT" -eq 65 ]; then
  NEW_LIMIT=100
  MESSAGE="Charging limit set to 100%"
else
  NEW_LIMIT=65
  MESSAGE="Charging limit set to 65%"
fi

# Apply the new limit (requires sudo)
echo "$NEW_LIMIT" | sudo tee "$THRESHOLD_FILE" >/dev/null

if [ $? -eq 0 ]; then
  # Save the new state
  echo "$NEW_LIMIT" >"$STATE_FILE"
  notify-send "Battery Limit" "$MESSAGE" -i battery
else
  notify-send "Battery Limit" "Failed to set limit. Check sudo permissions." -u critical
fi
