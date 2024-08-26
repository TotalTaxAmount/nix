MONITOR=$1
# Get the JSON data from `hyprctl monitors -j`
monitor_data=$(hyprctl monitors -j)

# Extract the monitor name based on the provided MONITOR ID
MON_TEXT=$(echo "$monitor_data" | jq -r --arg monitor_id "$MONITOR" \
  '.[] | select(.id == ($monitor_id | tonumber)) | .name')
# Check if MON_TEXT was found and is not empty
if [ -z "$MON_TEXT" ]; then
  echo "Monitor with ID $MONITOR not found."
  exit 1
fi

hyprland-activewindow $MON_TEXT
