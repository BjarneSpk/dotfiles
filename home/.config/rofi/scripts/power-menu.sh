#!/usr/bin/env bash

# set -euo

for cmd in rofi systemctl hyprlock hyprctl loginctl; do
  command -v "$cmd" >/dev/null 2>&1 || {
    notify-send "$TITLE" "Missing command: $cmd"
    exit 1
  }
done

options=(
  "  Lock"
  "  Suspend"
  "󰍃  Logout"
  "  Reboot"
  "  Shutdown"
)

if [[ -z "$1" ]]; then
  printf '%s\n' "${options[@]}"
else
  case "$1" in
    "  Lock")
      hyprlock
      ;;
    "  Suspend")
      sh -c 'hyprlock & sleep 0.5 && systemctl suspend'
      ;;
    "󰍃  Logout")
      hyprctl dispatch exit
      ;;
    "  Reboot")
      systemctl reboot
      ;;
    "  Shutdown")
      systemctl poweroff
      ;;
    *)
      exit 1
      ;;
  esac
fi
