#!/usr/bin/env bash
# -----------------------------------------------------
# Prevent duplicate launches: only the first parallel
# invocation proceeds; all others exit immediately.
# -----------------------------------------------------

exec 200>/tmp/waybar-launch.lock
flock -n 200 || exit 0

# -----------------------------------------------------
# Quit all running waybar instances
# -----------------------------------------------------

killall waybar || true
pkill waybar || true
# sleep 0.5

# Check if waybar-disabled file exists
HYPRLAND_SIGNATURE=$(hyprctl instances -j | jq -r '.[0].instance')
HYPRLAND_INSTANCE_SIGNATURE="$HYPRLAND_SIGNATURE" waybar &

# Explicitly release the lock (optional) -> flock releases on exit
flock -u 200
exec 200>&-
