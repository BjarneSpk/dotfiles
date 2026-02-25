#!/usr/bin/env bash

set -euo pipefail

ROFI_CONFIG="${XDG_CONFIG_HOME:=$HOME/.config}/rofi/config-wallpaper.rasi"

THEME_DIR=$HOME/Pictures/Wallpapers

RANDOM_WALL="$(find "$THEME_DIR" -maxdepth 1 -type f \
  \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) | shuf -n 1)"

SELECTED_WALL=$(
  {
    printf "󰒺  Random Wallpaper\0icon\x1f%s\n" "$RANDOM_WALL"

    find "$THEME_DIR" -maxdepth 1 -type f \
      \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) \
      -printf "%T@ %p\n" | sort -nr | cut -d' ' -f2- |
    while read -r img; do
      name="$(basename "$img")"
      printf "%s\0icon\x1f%s\n" "$name" "$img"
    done
  } |
  rofi -dmenu -i -p "Select Wallpaper" -show-icons -config "$ROFI_CONFIG"
)

[ -z "$SELECTED_WALL" ] && exit 0

if [[ "$SELECTED_WALL" == *Random* ]]; then
    SELECTED_PATH="$RANDOM_WALL"
else
    SELECTED_PATH="$THEME_DIR/$SELECTED_WALL"
fi

chwall $SELECTED_PATH
