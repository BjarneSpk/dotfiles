#!/usr/bin/env bash

set -euo pipefail

ROFI_CONFIG="${XDG_CONFIG_HOME:=$HOME/.config}/rofi/config-wallpaper.rasi"

THEME_DIR=$HOME/Pictures/Wallpapers

RANDOM_WALL="$(find "$THEME_DIR" \
  \( -path "$THEME_DIR/too_small" -o -path "$THEME_DIR/wallhaven" \) -prune -o \
  -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) -print | shuf -n 1)"

mapfile -t WALLS < <(
  find "$THEME_DIR" \
    \( -path "$THEME_DIR/too_small" -o -path "$THEME_DIR/wallhaven" \) -prune -o \
    -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) \
    -printf "%T@ %p\n" | sort -nr | cut -d' ' -f2-
)

SELECTED_INDEX=$(
  {
    printf "󰒺  Random Wallpaper\0icon\x1f%s\n" "$RANDOM_WALL"

    for img in "${WALLS[@]}"; do
      name="${img#$THEME_DIR/}"
      printf "%s\0icon\x1f%s\n" "$name" "$img"
    done
  } |
  rofi -dmenu -i -p "Select Wallpaper" -show-icons -config "$ROFI_CONFIG" -format 'i'
)

[ -z "$SELECTED_INDEX" ] && exit 0

if [ "$SELECTED_INDEX" -eq 0 ]; then
  SELECTED_PATH="$RANDOM_WALL"
else
  SELECTED_PATH="${WALLS[$((SELECTED_INDEX-1))]}"
fi

echo "$SELECTED_PATH"
